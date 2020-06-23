//
//  MainVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/21.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
  
  // MARK: - Properties
  
  let textBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("TEXT", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemYellow
    button.titleLabel?.font = .boldSystemFont(ofSize: 32)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleTextVC), for: .touchUpInside)
    return button
  }()
  
  let voiceBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("VOICE", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemPurple
    button.titleLabel?.font = .boldSystemFont(ofSize: 32)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleVoiceVC), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupNavigation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigation()
  }
  
  // MARK: - Setup
  
  func setupLayout() {
//    view.backgroundColor = .systemPurple
    
    [textBtn, voiceBtn].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let defaultPadding: CGFloat = 32
    NSLayoutConstraint.activate([
      textBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultPadding),
      textBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding),
      textBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding)
    ])
    
    NSLayoutConstraint.activate([
      voiceBtn.topAnchor.constraint(equalTo: textBtn.bottomAnchor, constant: defaultPadding / 2),
      voiceBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding),
      voiceBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding),
      voiceBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -defaultPadding),
      voiceBtn.heightAnchor.constraint(equalTo: textBtn.heightAnchor, multiplier: 1.0)
    ])
  }
  
  func setupNavigation() {
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.isHidden = true
  }
  
  // MARK: - Action
  
  @objc func handleTextVC(_ sender: UIButton) {
    let TVC = TextVC()
    navigationController?.pushViewController(TVC, animated: true)
  }
  
  @objc func handleVoiceVC(_ sender: UIButton) {
    let VVC = VoiceVC()
    navigationController?.pushViewController(VVC, animated: true)
    
  }
  
}
