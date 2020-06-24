//
//  UserListVC.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/24.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Firebase

class UserListVC: UIViewController {
  
  // MARK: - Properties
  
  private var usersList: [User] = []
  private var filterUsersList: [User] = []
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var isSearchMode: Bool {
    return searchController.isActive &&
      !searchController.searchBar.text!.isEmpty
  }
  
  lazy var logoutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Logout", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.backgroundColor = .systemGreen
    button.layer.cornerRadius = 20
    button.layer.borderColor = UIColor.systemGreen.cgColor
    button.layer.borderWidth = 1
    
    button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    return button
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    
    tableView.layer.cornerRadius = 20
    tableView.layer.borderColor = UIColor.systemGreen.cgColor
    tableView.layer.borderWidth = 3
    
    tableView.layer.shadowColor = UIColor.systemGreen.cgColor
    tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
    tableView.layer.shadowRadius = 5
    tableView.layer.shadowOpacity = 1.0
    
    tableView.tableFooterView = UIView()
    tableView.rowHeight = 80
    tableView.dataSource = self
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
    return tableView
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureSearchBar()
    configureNavi()
    getUsersData()
  }
  
  // MARK: - Helpers
  
  func getUsersData() {
    ConversationService.shared.getUsers { users in
      self.usersList = users
      self.tableView.reloadData()
    }
  }
  
  func configureSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.searchBar.showsCancelButton = false
    navigationItem.searchController = searchController
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a user"
    definesPresentationContext = false
    
    if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
      textField.textColor = .black
      textField.backgroundColor = .white
    }
  }
  
  func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(logoutButton)
    logoutButton.layout
      .leading(equalTo: view.leadingAnchor, constant: 32)
      .trailing(equalTo: view.trailingAnchor, constant: -32)
      .bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
      .heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(tableView)
    tableView.layout
      .top(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
      .leading(equalTo: view.leadingAnchor, constant: 32)
      .trailing(equalTo: view.trailingAnchor, constant: -32)
      .bottom(equalTo: logoutButton.topAnchor, constant: -32)
  }
  
  func configureNavi() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemGreen
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .systemGreen
    title = "User List"
  }
  
  // MARK: - Selectors
  
  @objc func handleLogout(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
      dismiss(animated: true, completion: nil)
    } catch {
      print("DEBUG: Error Singing out...")
    }
  }
  
}

// MARK: - UITableViewDataSource

extension UserListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearchMode ? filterUsersList.count : usersList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
    cell.userData = isSearchMode ? filterUsersList[indexPath.row] : usersList[indexPath.row]
    return cell
  }
}

// MARK: - UISearchResultsUpdating

extension UserListVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?.lowercased() else { return }
    filterUsersList = usersList.filter({ user -> Bool in
      return user.username.lowercased().contains(searchText)
    })
    self.tableView.reloadData()
  }
}
