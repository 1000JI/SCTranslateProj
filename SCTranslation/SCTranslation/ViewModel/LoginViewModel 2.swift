//
//  LoginViewModel.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Foundation

struct LoginViewModel {
  var email: String?
  var password: String?
  
  var isNotEmpty: Bool {
    return email?.isEmpty == false &&
      password?.isEmpty == false
  }
}
