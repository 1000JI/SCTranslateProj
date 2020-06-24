//
//  ConversationCell.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let identifier = "userListCell"
  
  var userData: User? {
    didSet {
      configure()
    }
  }
  
  let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.tintColor = .black
    return iv
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let emailTextLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    return label
  }()
  
  // MARK: - LifeCycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(iconImageView)
    iconImageView.layout.leading(equalTo: leadingAnchor, constant: 12)
      .centerY(equalTo: centerYAnchor)
    iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let stackView = UIStackView(arrangedSubviews: [
      usernameLabel, emailTextLabel
    ])
    stackView.axis = .vertical
    stackView.spacing = 4
    
    addSubview(stackView)
    stackView.layout
      .centerY(equalTo: centerYAnchor)
      .leading(equalTo: iconImageView.trailingAnchor, constant: 12)
      .trailing(equalTo: trailingAnchor, constant: -12)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func configure() {
    iconImageView.image = UIImage(systemName: "person.crop.circle")
    usernameLabel.text = userData?.username ?? ""
    emailTextLabel.text = userData?.email ?? ""
  }
  
}
