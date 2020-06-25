//
//  TalkVTop.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

protocol TalkVTopDelegate: class {
  func handleLanguage(with language: Language, isFrom: Bool)
  func handleChange(from: Language, to: Language)
  func handleDismiss()
}

class TalkVTop: UIView {
  // MARK: - Properties
  weak var delegate: TalkVTopDelegate?
  
  var toggleChange: Bool = false
  
  var configureLanguage: Language?
  
  var fromLanguageData: Language? = dataLanguages[0] {
    didSet {
      guard let contury = fromLanguageData?.country else { return }
      fromLanguageBtn.setTitle("\(contury)⇣", for: .normal)
    }
  }
  var toLanguageData: Language? = dataLanguages[1] {
    didSet {
      guard let contury = toLanguageData?.country else { return }
      toLanguageBtn.setTitle("\(contury)⇣", for: .normal)
    }
  }
  
  lazy var dismissBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "multiply"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Talk"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
    return label
  }()
  
  lazy var fromLanguageBtn: UIButton = {
    let button = UIButton(type: .system)
    if let language = fromLanguageData {
      button.setTitle("\(language.country)⇣", for: .normal)
    }
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .clear
    button.titleLabel?.font = .systemFont(ofSize: 18)
    button.addTarget(self, action: #selector(handleFromLanguage), for: .touchUpInside)
    return button
  }()
  
  lazy var toLanguageBtn: UIButton = {
    let button = UIButton(type: .system)
    if let language = toLanguageData {
      button.setTitle("\(language.country)⇣", for: .normal)
    }
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .clear
    button.titleLabel?.font = .systemFont(ofSize: 18)
    button.addTarget(self, action: #selector(handleToLanguage), for: .touchUpInside)
    return button
  }()
  
  lazy var changeLanguageBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "arrow.right.arrow.left"), for: .normal)
    button.tintColor = .white
    button.layer.borderWidth = 0.5
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.cornerRadius = 60 / 4
    button.clipsToBounds = true
    button.backgroundColor = .clear
    //    button.titleLabel?.font = .systemFont(ofSize: 18)
    button.addTarget(self, action: #selector(handleChangeLanguage), for: .touchUpInside)
    return button
  }()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let view = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1.0))
    view.backgroundColor = .lightGray
    addSubview(view)
  }
  
  // MARK: - Helpers
  private func setupLayout() {
    [dismissBtn, fromLanguageBtn, toLanguageBtn, changeLanguageBtn, titleLabel].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      dismissBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      dismissBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
    ])
    
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: dismissBtn.centerYAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      changeLanguageBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
      changeLanguageBtn.topAnchor.constraint(equalTo: topAnchor, constant: 40),
      changeLanguageBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      changeLanguageBtn.widthAnchor.constraint(equalToConstant: 60)
    ])
    
    NSLayoutConstraint.activate([
      fromLanguageBtn.centerYAnchor.constraint(equalTo: changeLanguageBtn.centerYAnchor),
      fromLanguageBtn.trailingAnchor.constraint(equalTo: changeLanguageBtn.leadingAnchor, constant: -6),
      fromLanguageBtn.widthAnchor.constraint(equalToConstant: 120)
    ])
    
    NSLayoutConstraint.activate([
      toLanguageBtn.centerYAnchor.constraint(equalTo: changeLanguageBtn.centerYAnchor),
      toLanguageBtn.leadingAnchor.constraint(equalTo: changeLanguageBtn.trailingAnchor , constant: 6),
      toLanguageBtn.widthAnchor.constraint(equalToConstant: 120)
    ])
  }
  
  
  // MARK: - Selectors
  @objc func handleDismiss() {
    delegate?.handleDismiss()
  }
  
  @objc func handleFromLanguage(_ sender: UIButton) {
    guard let data = fromLanguageData else { return }
    delegate?.handleLanguage(with: data, isFrom: true)
  }
  
  @objc func handleToLanguage(_ sender: UIButton) {
    guard let data = toLanguageData else { return }
    delegate?.handleLanguage(with: data, isFrom: false)
  }
  
  @objc func handleChangeLanguage(_ sender: UIButton) {
    toggleChange.toggle()
    
    let tempLanguage = fromLanguageData
    fromLanguageData = toLanguageData
    toLanguageData = tempLanguage
    
    delegate?.handleChange(from: fromLanguageData!, to: toLanguageData!)
    
    UIView.animate(withDuration: 0.3) {
      if self.toggleChange { self.changeLanguageBtn.transform = CGAffineTransform(rotationAngle: .pi) }
      else { self.changeLanguageBtn.transform = .identity }
    }
  }
}
