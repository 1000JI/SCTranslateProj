//
//  CustomTextField.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  
  init(placeholder: String) {
    super.init(frame: .zero)
    
    borderStyle = .none
    font = .systemFont(ofSize: 16)
    textColor = .white
    keyboardAppearance = .dark
    attributedPlaceholder = NSAttributedString(string: placeholder,
                                               attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    
    delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CustomTextField: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    endEditing(true)
    return true
  }
}
