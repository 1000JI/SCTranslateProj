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

struct ConversationService {
  
  static let shared = ConversationService()
  private init() { }
  
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
  
}
