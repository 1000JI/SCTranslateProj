//
//  RegisterVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = RegisterViewModel()
  private let iconImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "person.crop.circle")
    iv.tintColor = .white
    return iv
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  private lazy var emailContainerView: UIView = {
    return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
  }()
  
  private lazy var usernameContainerView: UIView = {
    return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: usernameTextField)
  }()
  
  private lazy var passwordContainerView: InputContainerView = {
    return InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
  }()
  
  private let emailTextField = CustomTextField(placeholder: "Email")
  private let usernameTextField = CustomTextField(placeholder: "Username")
  private let passwordTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.setTitleColor(.white, for: .normal)
    
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor
    button.alpha = 0.5
    
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    return button
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureTextFieldEvent()
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    setupLoginViewGradientLayer()
    
    view.addSubview(iconImage)
    iconImage.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      iconImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
      iconImage.widthAnchor.constraint(equalToConstant: 120),
      iconImage.heightAnchor.constraint(equalToConstant: 120)
    ])
    
    view.addSubview(dismissButton)
    dismissButton.layout
      .leading(equalTo: view.leadingAnchor, constant: 12)
      .top(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
    
    let stackView = UIStackView(arrangedSubviews: [
      emailContainerView,
      passwordContainerView,
      usernameContainerView,
      signUpButton
    ])
    stackView.axis = .vertical
    stackView.spacing = 8
    view.addSubview(stackView)
    stackView.layout
      .top(equalTo: iconImage.bottomAnchor, constant: 32)
      .leading(equalTo: view.leadingAnchor, constant: 32)
      .trailing(equalTo: view.trailingAnchor, constant: -32)
  }
  
  func configureTextFieldEvent() {
    [emailTextField, passwordTextField, usernameTextField].forEach {
      $0.addTarget(self, action: #selector(handleCheckEmpty(_:)), for: .editingChanged)
    }
    emailTextField.becomeFirstResponder()
  }
  
  // MARK: - Selectors
  
  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleRegister() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    guard let username = usernameTextField.text else { return }
    
    let registerInfoDatas = RegisterInfoDatas(
      email: email,
      password: password,
      username: username
    )
    
    AuthService.shared.createUser(registerInfoDatas: registerInfoDatas) { error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
    }
  }
  
  @objc func handleCheckEmpty(_ sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    } else if sender == passwordTextField {
      viewModel.password = sender.text
    } else if sender == usernameTextField {
      viewModel.username = sender.text
    }
    isEmptyStatus()
  }
  
  // MARK: - Actions
  
  func isEmptyStatus() {
    if viewModel.isNotEmpty {
      signUpButton.isEnabled = true
      signUpButton.alpha = 1.0
    } else {
      signUpButton.isEnabled = false
      signUpButton.alpha = 0.5
    }
  }
  
}
