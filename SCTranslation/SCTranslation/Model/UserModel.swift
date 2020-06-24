//
//  UserModel.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Foundation

struct User {
  let uid: String
  let username: String
  let email: String
  
  init(userData: [String: Any]) {
    self.uid = userData["uid"] as? String ?? ""
    self.username = userData["username"] as? String ?? ""
    self.email = userData["email"] as? String ?? ""
  }
}
