//
//  TalkUserCustomCell.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class TalkUserCustomCell: UITableViewCell {
  static let identifier = "ToCellID"
  
  lazy var userComment: UILabel = {
    let label = UILabel()
    label.text = "Testsdfsfsdfsdfsdlkfjsdlkfjfsdfsdfsdfldkfjlsdkjflsdkjflkdsjflsdkfjlsdkfj"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    label.sizeToFit()
    return label
  }()
  
  lazy var userCommentTranslate: UILabel = {
    let label = UILabel()
    label.text = "Testsdfssdfsdfsdfldkfjlsdkjflsdkjflkdsjflsdkfjlsdkfj"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    label.sizeToFit()
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
      dateFormatter.dateFormat = "hh:mm a"
      
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
    self.backgroundColor = .systemGreen
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
    [userComment, userName, userCommentTranslate, dateLabel].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //    [userComment, userCommentTranslate].forEach {
    //      $0.layer.shadowColor = UIColor.black.cgColor
    //      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    //      $0.layer.shadowRadius = 2
    //      $0.layer.shadowOpacity = 1.0
    //      $0.layer.borderColor = UIColor.lightGray.cgColor
    //      $0.layer.borderWidth = 0.3
    //    }
    
    [
      userName.centerYAnchor.constraint(equalTo: userComment.centerYAnchor),
      userName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      ].forEach { $0.isActive = true }
    
    [
      userComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -140),
      userComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      userComment.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 8),
      ].forEach { $0.isActive = true }
    
    [
      dateLabel.centerYAnchor.constraint(equalTo: userCommentTranslate.centerYAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -140),
      ].forEach { $0.isActive = true }
    
    [
      userCommentTranslate.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
      userCommentTranslate.topAnchor.constraint(equalTo: userComment.bottomAnchor, constant: 8),
      userCommentTranslate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      userCommentTranslate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      ].forEach { $0.isActive = true }
  }
  
  private func createDate() -> String {
    let formatter_time = DateFormatter()
    formatter_time.dateFormat = "HH:mm"
    let current_time_string = formatter_time.string(from: Date())
    
    return current_time_string
  }
  
}
