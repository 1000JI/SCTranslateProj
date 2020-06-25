//
//  TalkVBottom.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

protocol TalkBottomDelegate: class {
  func inputText(_ message: String)
}

class TalkVBottom: UIView {
  
  // MARK: - Properties
  
  weak var delegate: TalkBottomDelegate?
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.font = .systemFont(ofSize: 18)
    tv.text = ""
    tv.isScrollEnabled = false
    return tv
  }()
  
  lazy var returnKey: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
    button.tintColor = .black
    button.isEnabled = false
    button.alpha = 0.5
    button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
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
//    autoresizingMask = .flexibleHeight
    
    [textView, returnKey].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //    [
    //      textView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
    //      textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
    //      textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
    //      textView.heightAnchor.constraint(equalToConstant: 34)
    //      ].forEach { $0.isActive = true }
    //
    //    [
    //      returnKey.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
    //      returnKey.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5)
    //      ].forEach { $0.isActive = true }
    
    returnKey.top(equalTo: topAnchor, constant: 4)
      .trailing(equalTo: trailingAnchor, constant: -8)
    returnKey.widthAnchor.constraint(equalToConstant: 50).isActive = true
    returnKey.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    textView.top(equalTo: topAnchor, constant: 8)
      .leading(equalTo: leadingAnchor, constant: 8)
      .bottom(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4)
      .trailing(equalTo: returnKey.leadingAnchor, constant: -4)
    textView.heightAnchor.constraint(equalToConstant: 38).isActive = true
//    textView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
  }
  
  private func setupView() {
    self.backgroundColor = .systemGreen
  }
  
  private func setupTextView() {
    textView.layer.cornerRadius = 10
  }
  
  private func setupReturnKey() {
    
  }
  
  // MARK: - Selectors
  
  @objc func handleSendMessage() {
    guard let text = textView.text else { return }
    textView.text = ""
    textView.resignFirstResponder()
    delegate?.inputText(text)
  }
  
}
