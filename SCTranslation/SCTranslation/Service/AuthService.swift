//
//  AuthService.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Firebase

struct RegisterInfoDatas {
  let email: String
  let password: String
  let username: String
}

struct AuthService {
  
  static let shared = AuthService()
  private init() { }
  
  func createUser(registerInfoDatas: RegisterInfoDatas, completion: ((Error?) -> Void)?) {
    Auth.auth().createUser(
      withEmail: registerInfoDatas.email,
      password: registerInfoDatas.password) { (result, error) in
        if let error = error {
          completion!(error)
          return
        }
        
        guard let uid = result?.user.uid else { return }
        
        let data = ["email": registerInfoDatas.email,
                    "username": registerInfoDatas.username,
                    "uid": uid
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
    }
  }
  
}
