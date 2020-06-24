//
//  TextVC.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/21.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Firebase

class TextVC: UIViewController {
  
  // MARK: - Properties
  let translateBarView = TranslateBarView(frame: .zero)
  lazy var fromTextViewT = TranslateTextView(frame: .zero, with: fromLanguage)
  lazy var toTextViewT = TranslateTextView(frame: .zero, with: toLanguage)
  let mikeButtonView = MikeButtonView(frame: .zero)
  
  lazy var fromLanguage: Language? = translateBarView.fromLanguageData
  lazy var toLanguage: Language? = translateBarView.toLanguageData
  
  let textPlaceHolder: UILabel = {
    let label = UILabel()
    label.text = "번역할 내용을 입력하세요."
    label.textColor = .systemGray
    return label
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavi()
    configureFromTextView()
    setupLayout()
  }
  
  // MARK: - Setup
  
  private func setupLayout() {
    view.backgroundColor = .systemYellow
    
    [translateBarView, fromTextViewT, toTextViewT].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fromTextViewT.transTextView.addSubview(textPlaceHolder)
    textPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textPlaceHolder.centerYAnchor.constraint(equalTo: fromTextViewT.transTextView.centerYAnchor),
      textPlaceHolder.centerXAnchor.constraint(equalTo: fromTextViewT.transTextView.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      translateBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      translateBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      translateBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
      translateBarView.heightAnchor.constraint(equalToConstant: 50)
    ])
    translateBarView.delegate = self
    
    NSLayoutConstraint.activate([
      fromTextViewT.topAnchor.constraint(equalTo: translateBarView.bottomAnchor),
      fromTextViewT.widthAnchor.constraint(equalTo: view.widthAnchor),
      fromTextViewT.heightAnchor.constraint(equalToConstant: 200)
    ])
    
    NSLayoutConstraint.activate([
      toTextViewT.topAnchor.constraint(equalTo: fromTextViewT.bottomAnchor),
      toTextViewT.widthAnchor.constraint(equalTo: view.widthAnchor),
      toTextViewT.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    mikeButtonView.delegate = self
  }
  
  private func setupNavi() {
    let dismissBBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissBtn))
    
    title = "문자 번역"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bazzi", size: 20)!]
    
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.layoutIfNeeded()
    
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .systemYellow
    
    navigationItem.leftBarButtonItem = dismissBBtn
  }
  
  private func configureFromTextView() {
    fromTextViewT.transTextView.delegate = self
    fromTextViewT.transTextView.becomeFirstResponder()
  }
  
  // MARK: - Action
  
  private func textViewPlaceHolder(_ str: String) {
    if str.isEmpty {
      textPlaceHolder.alpha = 1
    } else {
      textPlaceHolder.alpha = 0
    }
  }
  
  @objc private func dismissBtn(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func textClearAction(_ sender: UIButton) {
    
    fromTextViewT.transTextView.text = ""
    let languageVC = LanguageVC()
    languageVC.delegate = self
    
    present(languageVC, animated: true)
  }
}

// MARK: - MikeButtonViewDelegate

extension TextVC: MikeButtonViewDelegate {
  func finishRecorder(_ voiceText: String) {
    fromTextViewT.displayText = voiceText
  }
}

// MARK: - UITextViewDelegate

extension TextVC: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    fromTextViewT.displayText = textView.text
    textViewPlaceHolder(textView.text)
    
    guard let sourceText = textView.text else { return }
    guard let from = fromLanguage else { return }
    guard let to = toLanguage else { return }
    
    TranslateService.translateText(
      from: from,
      to: to,
      sourceText: sourceText) { translateString in
        self.toTextViewT.displayText = translateString
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if (text == "\n") { textView.resignFirstResponder() }
    return true
  }
}

// MARK: - TranslateBarViewDelegate

extension TextVC: TranslateBarViewDelegate {
  func handleChange(from: Language, to: Language) {
    fromLanguage = from
    toLanguage = to
    
    fromTextViewT.configureLanguage = from
    toTextViewT.configureLanguage = to
    
    let tempDisplayText = fromTextViewT.displayText
    fromTextViewT.displayText = toTextViewT.displayText
    toTextViewT.displayText = tempDisplayText
  }
  
  func handleLanguage(with language: Language, isFrom: Bool) {
    let languageVC = LanguageVC()
    languageVC.selectedLanguage = language
    languageVC.isFrom = isFrom
    languageVC.delegate = self
    present(languageVC, animated: true)
  }
}

// MARK: - LanguageVCDelegate

extension TextVC: LanguageVCDelegate {
  func selectedLanguage(language: Language, isFrom: Bool) {
    if isFrom {
      translateBarView.fromLanguageData = language
      fromTextViewT.configureLanguage = language
      self.fromLanguage = language
    } else {
      translateBarView.toLanguageData = language
      toTextViewT.configureLanguage = language
      self.toLanguage = language
    }
    
  }
}
