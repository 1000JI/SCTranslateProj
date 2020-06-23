//
//  MikeButton.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class MikeButtonView: UIButton {
    
    // MARK: - Properties
    
    var animateTimer: Timer?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let symbolImage = UIImage(systemName: "mic", withConfiguration: configuration)
        setImage(symbolImage, for: .normal)
        
        backgroundColor = .systemPurple
        tintColor = .white
        
        // Autolayout
        let buttonSize: CGFloat = 80
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: buttonSize),
            heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        layer.cornerRadius = buttonSize / 2
    }
    
    func configureAction() {
        addTarget(self, action: #selector(handleRecorder(_:)), for: .touchUpInside)
    }
    
    // MARK: - Selecters
    
    @objc func handleRecorder(_ sender: UIButton) {
        sender.isSelected.toggle()
        print("DEBUG: ", sender.isSelected)
        
        if sender.isSelected {
            print("DEBUG: selected ", sender.isSelected)
            animateTimer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(handleAnimate),
                userInfo: nil,
                repeats: true)
        } else {
            print("DEBUG: deselected ", sender.isSelected)
            animateTimer?.invalidate()
        }
    }
    
    @objc func handleAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layer.shadowColor = UIColor.systemPurple.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 30
            self.layer.shadowOpacity = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.layer.shadowColor = UIColor.systemPurple.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.shadowRadius = 30
                self.layer.shadowOpacity = 0.0
            }
        }
    }
    
}
