//
//  MessageModel.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/25.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Foundation
import Firebase

struct Message {
  let originalMessage: String
  let translateMessage: String
  let toId: String
  let fromId: String
  let timestamp: Timestamp!
  var user: User?
  
  let isFromCurrentUser: Bool
  
  var chatPartnerId: String {
    return isFromCurrentUser ? toId : fromId
  }
  
  init(dataDictionary: [String: Any]) {
    self.originalMessage = dataDictionary["originalMessage"] as? String ?? ""
    self.translateMessage = dataDictionary["translateMessage"] as? String ?? ""
    self.toId = dataDictionary["toId"] as? String ?? ""
    self.fromId = dataDictionary["fromId"] as? String ?? ""
    self.timestamp = dataDictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    
    self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
  }
}
