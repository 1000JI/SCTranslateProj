//
//  ConversationService.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Firebase
import Foundation

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")

struct ConversationService {
  
  static let shared = ConversationService()
  private init() { }
  
  func getUser(completion: @escaping(User) -> Void) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
    COLLECTION_USERS.document(currentUid).getDocument { (snapshot, error) in
      if let error = error {
        print(#function, "DEBUG: \(error.localizedDescription)")
        return
      }
      
      guard let data = snapshot?.data() else { return }
      completion(User(userData: data))
    }
  }
  
  func getUsers(completion: @escaping([User]) -> Void) {
    COLLECTION_USERS.getDocuments { (snapshot, error) in
      if let error = error {
        print(#function, "DEBUG: \(error.localizedDescription)")
        return
      }
      
      guard var users = snapshot?.documents.map({ User(userData: $0.data()) }) else { return }
      
      if let myData = users.firstIndex(where: { user -> Bool in
        return user.uid == Auth.auth().currentUser?.uid
      }) {
        users.remove(at: myData)
      }
      
      completion(users)
    }
  }
  
  func uploadMessage(fromMessage originalMessage: String, toMessage translateMessage: String, to user: User, completion: ((Error?) -> Void)?) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
    let data = ["originalMessage": originalMessage,
                "translateMessage": translateMessage,
                "fromId": currentUid,
                "toId": user.uid,
                "timestamp": Timestamp(date: Date())] as [String : Any]
    
    COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
    }
  }
  
  func getMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    var messages: [Message] = []
    
    let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
    
    query.addSnapshotListener { (snapshot, error) in
      if snapshot?.documentChanges.count == 0 { completion(messages) }
      else {
        snapshot?.documentChanges.forEach({ document in
          if document.type == .added {
            let data = document.document.data()
            messages.append(Message(dataDictionary: data))
            completion(messages)
          }
        })
      }
    }
  }
}
