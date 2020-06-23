//
//  ButtonTitleLabel.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/23.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class ButtonTitleLabel: UILabel {
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    textColor = .black
    textAlignment = .center
    backgroundColor = .systemYellow
    font = .boldSystemFont(ofSize: 32)
    layer.cornerRadius = 28
    clipsToBounds = true
    isHidden = true
  }
}
