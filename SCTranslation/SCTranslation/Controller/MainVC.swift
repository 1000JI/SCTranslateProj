//
//  MainVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/21.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Lottie

class MainVC: UIViewController {
  
  // MARK: - Properties
  
  let animationView: AnimationView = {
    let animate = AnimationView(name: "Loading")
    animate.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
    animate.contentMode = .scaleAspectFill
    return animate
  }()
  
  lazy var textBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("문자 번역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemYellow
    button.titleLabel?.font = UIFont(name: "Bazzi", size: 44)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleTextVC), for: .touchUpInside)
    return button
  }()
  
  lazy var voiceBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("음성 번역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Bazzi", size: 44)
    button.backgroundColor = .systemPurple
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleVoiceVC), for: .touchUpInside)
    return button
  }()
  
  lazy var chatBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("번역 채팅", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemGreen
    button.titleLabel?.font = UIFont(name: "Bazzi", size: 44)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleChatVC(_:)), for: .touchUpInside)
    return button
  }()
  
  let textLabel = ButtonTitleLabel()
  let voiceLabel = ButtonTitleLabel()
  let chatLabel = ButtonTitleLabel()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAnimation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigation()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    titleLabelInit()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    titleLabelInit()
  }
  
  // MARK: - Setup
  
  func setupAnimation() {
    setupGradientLayer()
    view.addSubview(animationView)
    animationView.center = view.center

    animationView.play { finish in
      self.animationView.removeFromSuperview()

      self.setupLayout()
      self.setupNavigation()
    }
  }
  
  func setupLayout() {
    setupGradientLayer()
    
    [textBtn, voiceBtn, chatBtn].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 2
      $0.layer.shadowOpacity = 1.0
      
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.layer.borderWidth = 0.5
    }
    
    
    let defaultPadding: CGFloat = 32
    NSLayoutConstraint.activate([
      textBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultPadding),
      textBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding),
      textBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding)
    ])
    
    NSLayoutConstraint.activate([
      voiceBtn.topAnchor.constraint(equalTo: textBtn.bottomAnchor, constant: defaultPadding),
      voiceBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding),
      voiceBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding),
      voiceBtn.heightAnchor.constraint(equalTo: textBtn.heightAnchor, multiplier: 1.0)
    ])
    
    NSLayoutConstraint.activate([
      chatBtn.topAnchor.constraint(equalTo: voiceBtn.bottomAnchor, constant: defaultPadding),
      chatBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding),
      chatBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultPadding),
      chatBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -defaultPadding),
      chatBtn.heightAnchor.constraint(equalTo: voiceBtn.heightAnchor, multiplier: 1.0)
    ])
    
    [textLabel, voiceLabel, chatLabel].forEach { view.addSubview($0) }
  }
  
  func setupNavigation() {
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.isHidden = true
  }
  
  func titleLabelInit() {
    [(textLabel, textBtn), (voiceLabel, voiceBtn), (chatLabel,chatBtn)].forEach {
      $0.0.backgroundColor = $0.1.backgroundColor
      $0.0.frame = $0.1.frame
      $0.0.layer.cornerRadius = 28
      $0.0.isHidden = true
    }
  }
  
  // MARK: - Action
  
  func animateLabel(_ label: ButtonTitleLabel, toVC viewController: UIViewController) {
    label.isHidden = false
    UIView.animate(withDuration: 0.5) {
      label.frame = self.view.frame
      label.layer.cornerRadius = 0
      self.view.layoutIfNeeded()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
      let navi = UINavigationController(rootViewController: viewController)
      navi.modalPresentationStyle = .fullScreen
      navi.modalTransitionStyle = .crossDissolve
      self.present(navi, animated: true)
    }
  }
  
  @objc func handleTextVC(_ sender: UIButton) {
    animateLabel(textLabel, toVC: TextVC())
  }
  
  @objc func handleVoiceVC(_ sender: UIButton) {
    animateLabel(voiceLabel, toVC: VoiceVC())
  }
  
  @objc func handleChatVC(_ sender: UIButton) {
    let controller = LoginVC()
    controller.delegate = self
    animateLabel(chatLabel, toVC: controller)
  }
  
}

extension MainVC: LoginVCDelegate {
  func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}
