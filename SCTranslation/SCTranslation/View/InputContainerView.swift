//
//  InputContainerView.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class InputContainerView: UIView {
  
  init(image: UIImage?, textField: UITextField) {
    super.init(frame: .zero)
    
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let iv = UIImageView()
    iv.image = image
    iv.tintColor = .white
    iv.alpha = 0.87
    
    addSubview(iv)
    iv.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iv.centerYAnchor.constraint(equalTo: centerYAnchor),
      iv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      iv.widthAnchor.constraint(equalToConstant: 24),
      iv.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.centerYAnchor.constraint(equalTo: centerYAnchor),
      textField.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 8),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      textField.rightAnchor.constraint(equalTo: rightAnchor)
    ])
    
    let dividerView = UIView()
    dividerView.backgroundColor = .white
    addSubview(dividerView)
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      dividerView.rightAnchor.constraint(equalTo: rightAnchor),
      dividerView.heightAnchor.constraint(equalToConstant: 0.75)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
