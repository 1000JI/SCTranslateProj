//
//  Extension.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit


extension UIViewController {
  
  func setupGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.frame
    gradientLayer.locations = [0, 0.5, 1]
    
    gradientLayer.colors = [ UIColor.systemYellow.cgColor, UIColor.systemPurple.cgColor, UIColor.systemGreen.cgColor ]
    gradientLayer.shouldRasterize = true
    
    view.layer.addSublayer(gradientLayer)
  }
  
  func setupLoginViewGradientLayer() {
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.frame = view.frame
//    gradientLayer.locations = [0, 1]
//
//    gradientLayer.colors = [ UIColor.systemGreen.cgColor, UIColor.green.cgColor ]
//    gradientLayer.shouldRasterize = true
//
//    view.layer.addSublayer(gradientLayer)
    view.backgroundColor = .systemGreen
  }
  
}

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
  
  // MARK: - AutoLayoutAnchor Helper
  
  var layout: UIView {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }
  @discardableResult
  func top(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.topAnchor
    topAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
  @discardableResult
  func leading(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.leadingAnchor
    leadingAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
  @discardableResult
  func bottom(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.bottomAnchor
    bottomAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
  @discardableResult
  func trailing(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.trailingAnchor
    trailingAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
  @discardableResult
  func centerY(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.centerYAnchor
    centerYAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
  @discardableResult
  func centerX(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0) -> Self {
    let anchor = anchor ?? superview!.safeAreaLayoutGuide.centerXAnchor
    centerXAnchor.constraint(equalTo: anchor, constant: c).isActive = true
    return self
  }
}
