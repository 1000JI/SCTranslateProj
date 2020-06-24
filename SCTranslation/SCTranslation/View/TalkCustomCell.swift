//
//  TalkCustomCell.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class TalkCustomCell: UITableViewCell {
  let identifier = "FromCellID"
  lazy var userComment: UILabel = {
    let label = UILabel()
    label.text = "Test"
    label.textColor = .black
    label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    setupUserComment()
    setupContentView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentView() {
    self.backgroundColor = .systemGreen
  }
  
  private func setupUserComment() {
    contentView.addSubview(userComment)
  }
  
  private func setupLayout() {
    [userComment].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    [
      userComment.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      userComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
      ].forEach { $0.isActive = true }
  }
  
}
