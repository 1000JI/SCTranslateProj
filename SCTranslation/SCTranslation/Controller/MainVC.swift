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
  
  lazy var animationView: AnimationView = {
    let animate = AnimationView(name: "Loading")
    animate.frame = view.frame
    animate.contentMode = .scaleAspectFit
    animate.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    return animate
  }()
  
  private let titleFontSize: CGFloat = 52
  private let subFontSize: CGFloat = 24
  private let menuFontSize: CGFloat = 36
  
  lazy var textBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("문자 번역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .systemYellow
    button.titleLabel?.font = UIFont(name: "Bazzi", size: menuFontSize)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleTextVC), for: .touchUpInside)
    return button
  }()
  
  lazy var voiceBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("음성 번역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Bazzi", size: menuFontSize)
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
    button.titleLabel?.font = UIFont(name: "Bazzi", size: menuFontSize)
    button.layer.cornerRadius = 28
    button.addTarget(self, action: #selector(handleChatVC(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "SCTranslation"
    label.font = UIFont(name: "Bazzi", size: titleFontSize)
    label.textAlignment = .center
    label.textColor = .black
    return label
  }()
  
  lazy var subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "심플하고 편안한 번역"
    label.font = UIFont(name: "Bazzi", size: subFontSize)
    label.textAlignment = .center
    label.textColor = .black
    return label
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
    self.setupLayout()
    self.setupNavigation()
    
    view.addSubview(animationView)
    animationView.center = view.center
    
    animationView.play { finish in
      self.animationView.removeFromSuperview()
    }
  }
  
  func setupLayout() {
    setupGradientLayer()
    
    [titleLabel, subTitleLabel, textBtn, voiceBtn, chatBtn].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
      $0.layer.shadowRadius = 2
      $0.layer.shadowOpacity = 1.0
      
      if $0 != titleLabel, $0 != subTitleLabel {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
      }
    }
    
    let defaultPadding: CGFloat = 52
    let defaultSidePadding: CGFloat = 100
    let titleSubPadding: CGFloat = 4
    let titleSubVerticalPadding: CGFloat = 100
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleSubVerticalPadding),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleSubPadding),
      subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      textBtn.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: titleSubVerticalPadding),
      textBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultSidePadding),
      textBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultSidePadding)
    ])
    
    NSLayoutConstraint.activate([
      voiceBtn.topAnchor.constraint(equalTo: textBtn.bottomAnchor, constant: defaultPadding),
      voiceBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultSidePadding),
      voiceBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultSidePadding),
      voiceBtn.heightAnchor.constraint(equalTo: textBtn.heightAnchor, multiplier: 1.0)
    ])
    
    NSLayoutConstraint.activate([
      chatBtn.topAnchor.constraint(equalTo: voiceBtn.bottomAnchor, constant: defaultPadding),
      chatBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultSidePadding),
      chatBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -defaultSidePadding),
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
  
  @objc func handleMainAnimate() {
    UIView.animateKeyframes(
      withDuration: 4, // 몇 초 동안 Animation을 할 건지?
      delay: 0, // 몇 초 뒤에 Animation을 할 것 인지?
      options: [.allowUserInteraction],
      animations: {
        UIView.addKeyframe(
          withRelativeStartTime: 0, // 4 * 0 = 0, 해당 Keyframe의 시작 시간
          relativeDuration: 0.25 // 4 * 0.25 = 1, 해당 keyframe의 동작 시간
        ) {
          //          self.textBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        UIView.addKeyframe(
          withRelativeStartTime: 0.25, // 4 * 0.25 = 1
          relativeDuration: 0.25 // 4 * 0.25 = 1
        ) {
          self.textBtn.layer.shadowRadius = 2
          self.textBtn.layer.shadowOpacity = 1.0
          
          //          self.textBtn.transform = .identity
          //          self.voiceBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        UIView.addKeyframe(
          withRelativeStartTime: 0.5, // 4 * 0.5 = 2
          relativeDuration: 0.25 // 4 * 0.25 = 1
        ) {
          //          self.voiceBtn.transform = .identity
          //          self.chatBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        UIView.addKeyframe(
          withRelativeStartTime: 0.75, // 4 * 0.75 = 3
          relativeDuration: 0.25 // 4 * 0.25 = 1
        ) {
          //          self.chatBtn.transform = .identity
        }
    })
  }
  
}

extension MainVC: LoginVCDelegate {
  func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}
