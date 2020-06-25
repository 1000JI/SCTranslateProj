//
//  TalkUserCustomCell.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Speech

class TalkUserCustomCell: UITableViewCell {
  static let identifier = "ToCellID"
  
  let roundShadowUserComment = RoundShadowView()
  let roundShadowUserCommentTranslate = RoundShadowView()
  
  lazy var userComment: PaddingLabel = {
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
  
  lazy var userCommentTranslate: PaddingLabel = {
    let label = PaddingLabel()
    label.text = "TEST"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    label.adjustsFontSizeToFitWidth = true
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(tapGesture)
    return label
  }()
  
  lazy var userName: UILabel = {
    let label = UILabel()
    label.text = "성단빈"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 15)
    return label
  }()
  
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "\(createDate())"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 10)
    return label
  }()
  
  var toUser: User?
  
  var message: Message? {
    didSet {
      guard let receive = message else { return }
      guard let user = toUser else { return }
      userComment.text = receive.originalMessage
      userCommentTranslate.text = receive.translateMessage
      
      let date = receive.timestamp.dateValue()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      
      dateLabel.text = dateFormatter.string(from: date)
      userName.text = user.username
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    setupUserComment()
    setupContentView()
    setupUserCommentTranslate()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentView() {
    self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
  }
  
  private func setupUserComment() {
    userComment.numberOfLines = 0
    userComment.layer.cornerRadius = 5
    userComment.clipsToBounds = true
  }
  
  private func setupUserCommentTranslate() {
    userCommentTranslate.numberOfLines = 0
    userCommentTranslate.layer.cornerRadius = 5
    userCommentTranslate.clipsToBounds = true
  }
  
  private func setupLayout() {
    //    [myComment, myCommentTranslate].forEach {
    //      roundShadowView.addSubview($0)
    //      $0.translatesAutoresizingMaskIntoConstraints = false
    //    }
    [roundShadowUserComment, roundShadowUserCommentTranslate, userName].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    roundShadowUserComment.addSubview(userComment)
    roundShadowUserCommentTranslate.addSubview(userCommentTranslate)
    
    userComment.translatesAutoresizingMaskIntoConstraints = false
    userCommentTranslate.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    [
      userName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
    ].forEach { $0.isActive = true }
    
    [
      roundShadowUserComment.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
      roundShadowUserComment.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
      roundShadowUserComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      ].forEach { $0.isActive = true }
    
    [
      roundShadowUserCommentTranslate.widthAnchor.constraint(
        lessThanOrEqualToConstant: 250),
      roundShadowUserCommentTranslate.topAnchor.constraint(
        equalTo: roundShadowUserComment.bottomAnchor, constant: 8),
      roundShadowUserCommentTranslate.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: 8),
      roundShadowUserCommentTranslate.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor, constant: -8),
      ].forEach { $0.isActive = true }
    
    [
      userComment.topAnchor.constraint(equalTo: roundShadowUserComment.topAnchor),
      userComment.leadingAnchor.constraint(equalTo: roundShadowUserComment.leadingAnchor),
      userComment.trailingAnchor.constraint(equalTo: roundShadowUserComment.trailingAnchor),
      userComment.bottomAnchor.constraint(equalTo: roundShadowUserComment.bottomAnchor)
      ].forEach { $0.isActive = true }
    
    [
      userCommentTranslate.topAnchor.constraint(equalTo: roundShadowUserCommentTranslate.topAnchor),
      userCommentTranslate.leadingAnchor.constraint(equalTo: roundShadowUserCommentTranslate.leadingAnchor),
      userCommentTranslate.trailingAnchor.constraint(equalTo: roundShadowUserCommentTranslate.trailingAnchor),
      userCommentTranslate.bottomAnchor.constraint(equalTo: roundShadowUserCommentTranslate.bottomAnchor)
      ].forEach { $0.isActive = true }
    
    [
//      dateLabel.centerYAnchor.constraint(equalTo: roundShadowUserCommentTranslate.centerYAnchor),
      dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      dateLabel.leadingAnchor.constraint(equalTo: roundShadowUserCommentTranslate.trailingAnchor, constant: 8)
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

    SpeechService.shared.setupSpeech()
    SpeechService.shared.synthesizer.delegate = self
    
    let utterance = AVSpeechUtterance(string: userCommentTranslate.text ?? "")
    utterance.voice = AVSpeechSynthesisVoice(language: language.transVoice)
    utterance.rate = 0.4
    synthesizer.speak(utterance)
  }
  
}

// MARK: - AVSpeechSynthesizerDelegate

extension TalkUserCustomCell: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
  }
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    
  }
}
