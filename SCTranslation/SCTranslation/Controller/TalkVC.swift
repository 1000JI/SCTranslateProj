//
//  TalkVC.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/23.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Foundation

class TalkVC: UIViewController {
  let talkTableView = UITableView()
  let talkVTop = TalkVTop(frame: .zero)
  let talkVBottom = TalkVBottom(frame: .zero)
  
  var centerY: NSLayoutConstraint?
  var talkVBottomHeight: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGreen
    
    setupTableView()
    setupLayout()
    setupTalkVBottom()
    keyboardObserver()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
//    self.talkTableView.endEditing(true)
  }
  
  private func setupTableView() {
    talkTableView.backgroundColor = .systemGreen
    talkTableView.dataSource = self
    talkTableView.delegate = self
    talkTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    talkTableView.register(TalkCustomCell.self, forCellReuseIdentifier: TalkCustomCell().identifier)
  }
  
  private func setupLayout() {
    [talkVTop, talkVBottom, talkTableView].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      talkVTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      talkVTop.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      talkVTop.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      talkVTop.heightAnchor.constraint(equalToConstant: 80)
    ])
    
    NSLayoutConstraint.activate([
      talkVBottom.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      talkVBottom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
    centerY = talkVBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    centerY?.isActive = true
    
    talkVBottomHeight = talkVBottom.heightAnchor.constraint(equalToConstant: 80)
    talkVBottomHeight?.isActive = true
    
    NSLayoutConstraint.activate([
      talkTableView.bottomAnchor.constraint(equalTo: talkVBottom.topAnchor),
      talkTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      talkTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      talkTableView.topAnchor.constraint(equalTo: talkVTop.bottomAnchor)
    ])
  }
  
  private func setupTalkVBottom() {
    talkVBottom.textView.delegate = self
  }
  
  private func keyboardObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func textViewMoveUp(_ notification: NSNotification){
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.3, animations: {
        self.centerY?.constant -= keyboardSize.height
        self.talkVBottomHeight?.constant -= 30
        self.talkTableView.bottomAnchor.constraint(equalTo: self.talkVBottom.topAnchor).isActive = true
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @objc private func textViewMoveDown(_ notification: NSNotification){
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.3, animations: {
        self.centerY?.constant += keyboardSize.height
        self.talkVBottomHeight?.constant += 30
        self.talkTableView.bottomAnchor.constraint(equalTo: self.talkVBottom.topAnchor).isActive = true
        self.view.layoutIfNeeded()
      })
    }
  }
}

extension TalkVC: UITextViewDelegate {
  func textViewDidChangeSelection(_ textView: UITextView) {
    if textView.text.isEmpty {
      talkVBottom.returnKey.alpha = 0.0
    } else {
      talkVBottom.returnKey.alpha = 1.0
    }
  }
}

extension TalkVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 40
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TalkCustomCell().identifier, for: indexPath) as! TalkCustomCell
    
    cell.selectionStyle = .none
    
    return cell
  }
}

extension TalkVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    talkVBottom.textView.endEditing(true)
  }
}
