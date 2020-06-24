//
//  VoiceVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class VoiceVC: UIViewController {
  
  // MARK: - Properties
  
  let translateBarView = TranslateBarView(frame: .zero)
  let mikeButtonView = MikeButtonView(frame: .zero)
  lazy var fromTextView = TranslateTextView(frame: .zero)
  lazy var toTextView = TranslateTextView(frame: .zero, isFrom: false)
  
  lazy var fromLanguage: Language? = translateBarView.fromLanguageData
  lazy var toLanguage: Language? = translateBarView.toLanguageData
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureNavi()
    configureFromTextView()
  }
  
  // MARK: - Helpers
  
  func configureFromTextView() {
    fromTextView.transTextView.delegate = self
  }
  
  func configureUI() {
    view.backgroundColor = .systemPurple
    
    [translateBarView, fromTextView, toTextView, mikeButtonView].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      translateBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      translateBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      translateBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
      translateBarView.heightAnchor.constraint(equalToConstant: 50)
    ])
    translateBarView.delegate = self
    
    NSLayoutConstraint.activate([
      mikeButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      mikeButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
    ])
    mikeButtonView.delegate = self
    
    NSLayoutConstraint.activate([
      fromTextView.topAnchor.constraint(equalTo: translateBarView.bottomAnchor),
      fromTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
      fromTextView.heightAnchor.constraint(equalToConstant: 200)
    ])
    
    NSLayoutConstraint.activate([
      toTextView.topAnchor.constraint(equalTo: fromTextView.bottomAnchor),
      toTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
      toTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    fromTextView.configureLanguage = fromLanguage
    toTextView.configureLanguage = toLanguage
  }
  
  func configureNavi() {
    let dismissBBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissBtn))
    
    title = "음성 번역"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bazzi", size: 20)!]
    
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.layoutIfNeeded()
    
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .systemPurple
    
    navigationItem.leftBarButtonItem = dismissBBtn
  }
  
  // MARK: - Selectors
  
  @objc private func dismissBtn() {
    dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - MikeButtonViewDelegate

extension VoiceVC: MikeButtonViewDelegate {
  func finishRecorder(_ voiceText: String) {
    guard let fromLang = translateBarView.fromLanguageData else { return }
    guard let toLang = translateBarView.toLanguageData else { return }
    
    fromTextView.displayText = voiceText
    
    TranslateService.translateText(
      from: fromLang,
      to: toLang,
      sourceText: voiceText) { translateText in
        self.toTextView.displayText = translateText
    }
    
  }
}

// MARK: - TranslateBarViewDelegate

extension VoiceVC: TranslateBarViewDelegate {
  func handleChange(from: Language, to: Language) {
    fromLanguage = from
    toLanguage = to
    
    mikeButtonView.configureLanguage = from
    fromTextView.configureLanguage = from
    toTextView.configureLanguage = to
    
    let tempDisplayText = fromTextView.displayText
    fromTextView.displayText = toTextView.displayText
    toTextView.displayText = tempDisplayText
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

extension VoiceVC: LanguageVCDelegate {
  func selectedLanguage(language: Language, isFrom: Bool) {
    if isFrom {
      mikeButtonView.configureLanguage = language
      translateBarView.fromLanguageData = language
      fromTextView.configureLanguage = language
      self.fromLanguage = language
    } else {
      translateBarView.toLanguageData = language
      toTextView.configureLanguage = language
      self.toLanguage = language
    }
  }
}


extension VoiceVC: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    fromTextView.displayText = textView.text
    
    guard let sourceText = textView.text else { return }
    guard let from = fromLanguage else { return }
    guard let to = toLanguage else { return }
    
    TranslateService.translateText(
      from: from,
      to: to,
      sourceText: sourceText) { translateString in
        self.toTextView.displayText = translateString
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if (text == "\n") { textView.resignFirstResponder() }
    return true
  }
}
