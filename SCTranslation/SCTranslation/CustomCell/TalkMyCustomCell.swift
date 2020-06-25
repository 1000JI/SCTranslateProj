//
//  TalkMyCustomCell.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class TalkMyCustomCell: UITableViewCell {
  static let identifier = "FromCellID"
  
  lazy var myComment: UILabel = {
    let label = UILabel()
    label.text = "Testsdfsfsdfsdfsdlkfjsdlkfjfsdfsdfsdfldkfjlsdkjflsdkjflkdsjflsdkfjlsdkfj"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    label.sizeToFit()
    return label
  }()
  
  lazy var myCommentTranslate: UILabel = {
    let label = UILabel()
    label.text = "Testsdfssdfsdfsdfldkfjlsdkjflsdkjflkdsjflsdkfjlsdkfj"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    label.sizeToFit()
    return label
  }()
  
  lazy var date: UILabel = {
    let label = UILabel()
    label.text = "\(createDate())"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 10)
    return label
  }()
  
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
    self.backgroundColor = .systemGreen
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
    [myComment, myCommentTranslate, date].forEach {
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
      myComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 140),
      myComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      myComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      ].forEach { $0.isActive = true }
    
    [
      date.centerYAnchor.constraint(equalTo: myCommentTranslate.centerYAnchor),
      date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 140),
      ].forEach { $0.isActive = true }
    
    [
      myCommentTranslate.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: 8),
      myCommentTranslate.topAnchor.constraint(equalTo: myComment.bottomAnchor, constant: 8),
      myCommentTranslate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      myCommentTranslate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      ].forEach { $0.isActive = true }
  }
  
  private func createDate() -> String {
    let formatter_time = DateFormatter()
    formatter_time.dateFormat = "HH:mm"
    let current_time_string = formatter_time.string(from: Date())
    
    return current_time_string
  }
  
}
