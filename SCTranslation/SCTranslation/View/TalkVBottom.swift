//
//  TalkVBottom.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/23.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class TalkVBottom: UIView {
  // MARK: - Properties
  let textView = UITextView()
  lazy var returnKey: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("🖋", for: .normal)
    button.alpha = 0.0
    return button
  }()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayout()
    setupTextView()
    setupView()
    setupReturnKey()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  private func setupLayout() {
    [textView, returnKey].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    [
      textView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
      textView.heightAnchor.constraint(equalToConstant: 30)
      ].forEach { $0.isActive = true }
    
    [
      returnKey.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
      returnKey.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 2)
    ].forEach { $0.isActive = true }
  }
  
  private func setupView() {
    self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
  }
  
  private func setupTextView() {
    textView.layer.cornerRadius = 10
  }
  
  private func setupReturnKey() {
    
  }
  
  // MARK: - Selectors
  
  
}
