//
//  TalkMyCustomCell.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Speech

class TalkMyCustomCell: UITableViewCell {
  static let identifier = "FromCellID"
  
  let roundShadowMyComment = RoundShadowView()
  let roundShadowMyCommentTranslate = RoundShadowView()
  
  lazy var myComment: PaddingLabel = {
    let label = PaddingLabel()
    label.text = "TEST"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
  private let synthesizer = AVSpeechSynthesizer()
  
  var translateLanguage: Language?
  
  lazy var myCommentTranslate: PaddingLabel = {
    let label = PaddingLabel()
    label.text = "TEST"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    label.adjustsFontSizeToFitWidth = true
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(tapGesture)
    return label
  }()
  
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "\(createDate())"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 10)
    return label
  }()
  
  var message: Message? {
    didSet {
      guard let receive = message else { return }
      myComment.text = receive.originalMessage
      myCommentTranslate.text = receive.translateMessage
      
      let date = receive.timestamp.dateValue()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      
      dateLabel.text = dateFormatter.string(from: date)
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    setupMyComment()
    setupContentView()
    setupMyCommentTranslate()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentView() {
    self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
  }
  
  private func setupMyComment() {
    myComment.numberOfLines = 0
    myComment.layer.cornerRadius = 5
    myComment.clipsToBounds = true
  }
  
  private func setupMyCommentTranslate() {
    myCommentTranslate.numberOfLines = 0
    myCommentTranslate.layer.cornerRadius = 5
    myCommentTranslate.clipsToBounds = true
  }
  
  private func setupLayout() {
    //    [myComment, myCommentTranslate].forEach {
    //      roundShadowView.addSubview($0)
    //      $0.translatesAutoresizingMaskIntoConstraints = false
    //    }
    [roundShadowMyComment, roundShadowMyCommentTranslate].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    roundShadowMyComment.addSubview(myComment)
    roundShadowMyCommentTranslate.addSubview(myCommentTranslate)
    
    myComment.translatesAutoresizingMaskIntoConstraints = false
    myCommentTranslate.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    [
      roundShadowMyComment.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
      roundShadowMyComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      roundShadowMyComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      ].forEach { $0.isActive = true }
    
    [
      roundShadowMyCommentTranslate.widthAnchor.constraint(
        lessThanOrEqualToConstant: 250),
      roundShadowMyCommentTranslate.topAnchor.constraint(
        equalTo: roundShadowMyComment.bottomAnchor, constant: 8),
      roundShadowMyCommentTranslate.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -8),
      roundShadowMyCommentTranslate.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor, constant: -8),
      ].forEach { $0.isActive = true }
    
    [
      myComment.topAnchor.constraint(equalTo: roundShadowMyComment.topAnchor),
      myComment.leadingAnchor.constraint(equalTo: roundShadowMyComment.leadingAnchor),
      myComment.trailingAnchor.constraint(equalTo: roundShadowMyComment.trailingAnchor),
      myComment.bottomAnchor.constraint(equalTo: roundShadowMyComment.bottomAnchor)
      ].forEach { $0.isActive = true }
    
    [
      myCommentTranslate.topAnchor.constraint(equalTo: roundShadowMyCommentTranslate.topAnchor),
      myCommentTranslate.leadingAnchor.constraint(equalTo: roundShadowMyCommentTranslate.leadingAnchor),
      myCommentTranslate.trailingAnchor.constraint(equalTo: roundShadowMyCommentTranslate.trailingAnchor),
      myCommentTranslate.bottomAnchor.constraint(equalTo: roundShadowMyCommentTranslate.bottomAnchor)
      ].forEach { $0.isActive = true }
    
    [
//      dateLabel.centerYAnchor.constraint(equalTo: roundShadowMyCommentTranslate.centerYAnchor),
      dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      dateLabel.trailingAnchor.constraint(equalTo: roundShadowMyCommentTranslate.leadingAnchor, constant: -8)
      ].forEach { $0.isActive = true }
    
  }
  
  private func createDate() -> String {
    let formatter_time = DateFormatter()
    formatter_time.dateFormat = "HH:mm"
    let current_time_string = formatter_time.string(from: Date())
    
    return current_time_string
  }
  
  // MARK: - Selectors
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    handleSpeaker()
  }
  
  // MARK: - Helpers
  
  func handleSpeaker() {
    guard let language = translateLanguage else { return }

    synthesizer.delegate = self
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSession.Category.ambient)
      try audioSession.setMode(AVAudioSession.Mode.measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("audioSession properties weren't set because of an error.")
    }
    
    let utterance = AVSpeechUtterance(string: myCommentTranslate.text ?? "")
    utterance.voice = AVSpeechSynthesisVoice(language: language.transVoice)
    utterance.rate = 0.4
    synthesizer.speak(utterance)
  }
  
  
}

class PaddingLabel: UILabel {
  var padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
  
  public override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + padding.left + padding.right,
                  height: size.height + padding.top + padding.bottom)
  }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TalkMyCustomCell: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    
  }
}
