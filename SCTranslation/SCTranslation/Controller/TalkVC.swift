//
//  TalkVC.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

class TalkVC: UIViewController {
  
  // MARK: - Properties
  let talkTableView = UITableView()
  let talkVTop = TalkVTop(frame: .zero)
  lazy var talkVBottom = TalkVBottom(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
  
  lazy var fromLanguage: Language? = talkVTop.fromLanguageData
  lazy var toLanguage: Language? = talkVTop.toLanguageData
  
  var talkVBottomCenterY: NSLayoutConstraint?
  var talkVBottomHeight: NSLayoutConstraint?
  
  var talkUser: User?
  private var messages: [Message] = []
  
  override var inputAccessoryView: UIView? {
      get { return talkVBottom }
  }
  
  override var canBecomeFirstResponder: Bool {
      return true
  }
  
  // MARK: - LifeCycle
  
  init(with user: User) {
    self.talkUser = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGreen
    
    setupTableView()
    setupLayout()
    setupTalkVBottom()
    setupTalkVTop()
    getMessages()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    scrollToBottom()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  // MARK: - Helpers
  
  func getMessages() {
    guard let toTalkUser = talkUser else { return }
    ConversationService.shared.getMessages(forUser: toTalkUser) { messages in
      self.messages = messages
      self.talkTableView.reloadData()
      self.scrollToBottom()
    }
  }
  
  private func setupTableView() {
    talkTableView.backgroundColor = .systemGreen
    talkTableView.dataSource = self
    talkTableView.delegate = self
    talkTableView.rowHeight = UITableView.automaticDimension
    talkTableView.estimatedRowHeight = 60
    talkTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    talkTableView.alwaysBounceVertical = true
    talkTableView.keyboardDismissMode = .interactive
    talkTableView.register(TalkMyCustomCell.self, forCellReuseIdentifier: TalkMyCustomCell.identifier)
    talkTableView.register(TalkUserCustomCell.self, forCellReuseIdentifier: TalkUserCustomCell.identifier)
  }
  
  private func setupLayout() {
    [talkVTop, talkTableView].forEach {
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
      talkTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
      talkTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      talkTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      talkTableView.topAnchor.constraint(equalTo: talkVTop.bottomAnchor)
    ])
    
  }
  
  private func setupTalkVTop() {
    talkVTop.delegate = self
  }
  
  private func setupTalkVBottom() {
    talkVBottom.textView.delegate = self
    talkVBottom.delegate = self
  }
  
  // MARK: - Selectors
  
  func scrollToBottom() {
    guard messages.count > 0 else { return }
    let endIndex = IndexPath(row: messages.count - 1, section: 0)
    self.talkTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
  }
}

// MARK: - UITextViewDelegate

extension TalkVC: UITextViewDelegate {
  func textViewDidChangeSelection(_ textView: UITextView) {
    let size = CGSize(width: textView.bounds.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    
    textView.constraints.forEach { (constrant) in
      if constrant.firstAttribute == .height {
        constrant.constant = estimatedSize.height
      }
    }
    
    
    if textView.text.isEmpty {
      talkVBottom.returnKey.alpha = 0.5
      talkVBottom.returnKey.isEnabled = false
    } else {
      talkVBottom.returnKey.alpha = 1.0
      talkVBottom.returnKey.isEnabled = true
    }
  }
}

// MARK: - UITableViewDataSource

extension TalkVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
    if messages[indexPath.row].isFromCurrentUser {
      cell = tableView.dequeueReusableCell(withIdentifier: TalkMyCustomCell.identifier, for: indexPath) as! TalkMyCustomCell
      (cell as! TalkMyCustomCell).message = messages[indexPath.row]
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: TalkUserCustomCell.identifier, for: indexPath) as! TalkUserCustomCell
      (cell as! TalkUserCustomCell).toUser = talkUser
      (cell as! TalkUserCustomCell).message = messages[indexPath.row]
    }
    
    cell.selectionStyle = .none
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension TalkVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    talkVBottom.textView.endEditing(true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return UITableView.automaticDimension
  }
}

// MARK: - TalkVTopDelegate

extension TalkVC: TalkVTopDelegate {
  func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  func handleChange(from: Language, to: Language) {
    fromLanguage = from
    toLanguage = to
    
    talkVTop.configureLanguage = from
    talkVTop.configureLanguage = to
  }
  
  func handleLanguage(with language: Language, isFrom: Bool) {
    let languageVC = LanguageVC()
    languageVC.selectedLanguage = language
    languageVC.isFrom = isFrom
    languageVC.delegate = self
    present(languageVC, animated: true)
  }
}

// MARK: - LanguageVCDelegate

extension TalkVC: LanguageVCDelegate {
  func selectedLanguage(language: Language, isFrom: Bool) {
    if isFrom {
      talkVTop.fromLanguageData = language
      talkVTop.configureLanguage = language
      self.fromLanguage = language
    } else {
      talkVTop.toLanguageData = language
      talkVTop.configureLanguage = language
      self.toLanguage = language
    }
  }
}

// MARK: - TalkBottomDelegate

extension TalkVC: TalkBottomDelegate {
  func inputText(_ message: String) {
    guard let fromLang = fromLanguage else { return }
    guard let toLang = toLanguage else { return }
    guard let toUser = talkUser else { return }
    
    TranslateService.translateText(from: fromLang, to: toLang, sourceText: message) { translateMessage in
      ConversationService.shared.uploadMessage(
        fromMessage: message,
        toMessage: translateMessage,
        to: toUser) { error in
          if let error = error {
            self.showError(error.localizedDescription)
          }
      }
    }
  }
}
