//
//  LoginVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = LoginViewModel()
  private let iconImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "text.bubble")
    iv.tintColor = .white
    return iv
  }()
  
  private lazy var emailContainerView: UIView = {
    let containerView = InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"),
                                           textField: emailTextField)
    return containerView
  }()
  
  private lazy var passwordContainerView: InputContainerView = {
    let containerView = InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                           textField: passwordTextField)
    return containerView
  }()
  
  private let emailTextField = CustomTextField(placeholder: "Email")
  
  private let passwordTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private lazy var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log In", for: .normal)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.alpha = 0.5
    
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor
    button.setTitleColor(.white, for: .normal)
    
    button.layout.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private lazy var joinUserButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(
      string: "Don't have an account? ",
      attributes: [.font: UIFont.systemFont(ofSize: 16),
                   .foregroundColor: UIColor.white]
    )
    
    attributedTitle.append(NSMutableAttributedString(
      string: "Sign Up",
      attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                   .foregroundColor: UIColor.white])
    )
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleJoin), for: .touchUpInside)
    return button
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureNavi()
    configureTextFieldEvent()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    authCheckUser()
  }
  
  // MARK: - Helpers
  
  func userListVCPresent() {
    let userListVC = UserListVC()
    let navi = UINavigationController(rootViewController: userListVC)
    navi.modalPresentationStyle = .fullScreen
    present(navi, animated: true)
  }
  
  func authCheckUser() {
    if Auth.auth().currentUser?.uid != nil {
      userListVCPresent()
    }
  }
  
  func configureTextFieldEvent() {
    [emailTextField, passwordTextField].forEach {
      $0.addTarget(self, action: #selector(handleCheckEmpty(_:)), for: .editingChanged)
    }
  }
  
  func configureUI() {
    //    view.backgroundColor = .systemGreen
    setupLoginViewGradientLayer()
    
    [iconImage].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        iconImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
        iconImage.widthAnchor.constraint(equalToConstant: 120),
        iconImage.heightAnchor.constraint(equalToConstant: 120)
      ])
    }
    
    let stackView = UIStackView(arrangedSubviews: [
      emailContainerView,
      passwordContainerView,
      loginButton
    ])
    stackView.axis = .vertical
    stackView.spacing = 16
    
    view.addSubview(stackView)
    stackView.layout
      .top(equalTo: iconImage.bottomAnchor, constant: 32)
      .leading(equalTo: view.leadingAnchor, constant: 32)
      .trailing(equalTo: view.trailingAnchor, constant: -32)
    
    view.addSubview(joinUserButton)
    joinUserButton.layout
      .leading(equalTo: view.leadingAnchor, constant: 32)
      .trailing(equalTo: view.trailingAnchor, constant: -32)
      .bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
    
    view.addSubview(dismissButton)
    dismissButton.layout
      .leading(equalTo: view.leadingAnchor, constant: 12)
      .top(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
  }
  
  func configureNavi() {
    navigationController?.navigationBar.isHidden = true
  }
  
  // MARK: - Selectors
  
  @objc func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.shared.loginUser(withEmail: email, password: password) { (result, error) in
      if let error = error {
        print(#function, "DEBUG: ", error.localizedDescription)
        return
      }
      self.userListVCPresent()
    }
  }
  
  @objc func handleJoin() {
    let registerVC = RegisterVC()
    registerVC.modalPresentationStyle = .fullScreen
    present(registerVC, animated: true)
  }
  
  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleCheckEmpty(_ sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    } else if sender == passwordTextField {
      viewModel.password = sender.text
    }
    isEmptyStatus()
  }
  
  // MARK: - Actions
  
  func isEmptyStatus() {
    if viewModel.isNotEmpty {
      loginButton.isEnabled = true
      loginButton.alpha = 1.0
    } else {
      loginButton.isEnabled = false
      loginButton.alpha = 0.5
    }
  }
  
}
