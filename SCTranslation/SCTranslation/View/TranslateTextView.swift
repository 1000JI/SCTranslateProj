//
//  TranslateTextView.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateTextView: UIView {
  
  // MARK: - Properties
  
  private let textSpeakerBtnWidth: CGFloat = 48
  private let defaultButtonHeight: CGFloat = 28
  private let defaultPadding: CGFloat = 16
  
  private let synthesizer = AVSpeechSynthesizer()
  
  var displayText: String? {
    didSet {
      guard let text = displayText else { return }
      transTextView.text = text
    }
  }
  
  var configureLanguage: Language?
  
  lazy var textSpeakerBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "speaker.2"), for: .normal)
    button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
    
    button.backgroundColor = .clear
    button.tintColor = .white
    button.layer.cornerRadius = textSpeakerBtnWidth / 4
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 0)
    button.layer.shadowRadius = 2
    button.layer.shadowOpacity = 1.0
    
    button.addTarget(self, action: #selector(handleSpeaker), for: .touchUpInside)
    return button
  }()
  
  let closeBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
    
    button.tintColor = .black
    button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
    return button
  }()
  
  lazy var transTextView: UITextView = {
    let tv = UITextView()
    tv.font = .boldSystemFont(ofSize: 18)
    tv.text = ""
    tv.backgroundColor = .clear
    return tv
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
  }
  
  convenience init(frame: CGRect, with language: Language?) {
    self.init(frame: frame)
    
    configureLanguage = language
  }
  
  convenience init(frame: CGRect, isFrom: Bool) {
    self.init(frame: frame)
    if !isFrom {
      closeBtn.isHidden = true
      transTextView.isEditable = false
    }
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
  
  func configureUI() {
    backgroundColor = .clear
    
    [textSpeakerBtn, closeBtn, transTextView].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      textSpeakerBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultPadding),
      textSpeakerBtn.topAnchor.constraint(equalTo: topAnchor, constant: defaultPadding),
      textSpeakerBtn.widthAnchor.constraint(equalToConstant: textSpeakerBtnWidth),
      textSpeakerBtn.heightAnchor.constraint(equalToConstant: defaultButtonHeight)
    ])
    
    NSLayoutConstraint.activate([
      closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultPadding),
      closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: defaultPadding),
      closeBtn.widthAnchor.constraint(equalToConstant: defaultButtonHeight),
      closeBtn.heightAnchor.constraint(equalToConstant: defaultButtonHeight)
    ])
    
    NSLayoutConstraint.activate([
      transTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultPadding),
      transTextView.topAnchor.constraint(equalTo: textSpeakerBtn.bottomAnchor, constant: 20),
      transTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultPadding),
      transTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultPadding)
    ])
  }
  
  // MARK: - Selectors
  
  @objc func handleSpeaker(_ sender: UIButton) {
    guard let language = configureLanguage else { return }

    SpeechService.shared.setupSpeech()
    SpeechService.shared.synthesizer.delegate = self
    
    let utterance = AVSpeechUtterance(string: transTextView.text)
    utterance.voice = AVSpeechSynthesisVoice(language: language.transVoice)
    utterance.rate = 0.4
    synthesizer.speak(utterance)
  }
  @objc func handleClose(_ sender: UIButton) {
    transTextView.text = ""
  }
  
}

// MARK: - AVSpeechSynthesizerDelegate

extension TranslateTextView: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    textSpeakerBtn.isEnabled = true
    textSpeakerBtn.alpha = 1
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    textSpeakerBtn.isEnabled = false
    textSpeakerBtn.alpha = 0.5
  }
}
