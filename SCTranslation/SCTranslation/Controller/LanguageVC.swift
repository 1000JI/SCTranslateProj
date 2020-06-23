//
//  LanguageVC.swift
//  SCTranslation
//
//  Created by 성단빈 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit

protocol LanguageVCDelegate: class {
  func selectedLanguage(language: Language, isFrom: Bool)
}

class LanguageVC: UIViewController {
  
  // MARK: - Properties
  var selectedLanguage: Language?
  var isFrom: Bool?
  
  weak var delegate: LanguageVCDelegate?
  
  let tableView = UITableView()
  let topView = UIView()
  
  lazy var dismissBtn: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(systemName: "multiply"), for: .normal)
    btn.tintColor = .black
    btn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
    return btn
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "이 언어로 입력"
    label.textAlignment = .center
    label.textColor = .black
    return label
  }()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupUI()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let bottomBorder = UIView(frame: CGRect(x: 0, y: topView.frame.height - 1, width: topView.frame.width, height: 1.0))
    bottomBorder.backgroundColor = .lightGray
    topView.addSubview(bottomBorder)
  }
  
  // MARK: - Setup
  private func setupLayout() {
    [tableView, topView].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    [
      topView.topAnchor.constraint(equalTo: view.topAnchor),
      topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topView.heightAnchor.constraint(equalToConstant: 60)
      ].forEach { $0.isActive = true }
    
    [
    tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ].forEach { $0.isActive = true }
    
    [dismissBtn, titleLabel].forEach {
      topView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    [
      titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
    ].forEach { $0.isActive = true }
    
    [
      dismissBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
      dismissBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20)
    ].forEach { $0.isActive = true }
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 60
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
    tableView.tableFooterView = UIView()
  }
  
  // MARK: - Action
  
  @objc private func dismissAction(_ sender: UIButton) {
    dismiss(animated: true)
  }
}

extension LanguageVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataLanguages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell")
      ?? UITableViewCell(style: .value1, reuseIdentifier: "LanguageCell")
    cell.textLabel?.text = dataLanguages[indexPath.row].country
    
    if let selected = selectedLanguage {
      if dataLanguages[indexPath.row].country == selected.country {
        cell.textLabel?.textColor = .systemGreen
      }
    }
    
    cell.accessoryType = .disclosureIndicator
    
    return cell
  }
}

// MARK: - UITableViewDelegate

extension LanguageVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let isFrom = isFrom {
      delegate?.selectedLanguage(language: dataLanguages[indexPath.row], isFrom: isFrom)
    }
    dismiss(animated: true)
  }
}
