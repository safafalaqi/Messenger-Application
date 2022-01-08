//
//  NewConversationViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import JGProgressHUD
import SwiftUI

class NewConversationViewController: UIViewController , UISearchBarDelegate{
    
    private let spinner = JGProgressHUD()
    
    
    private var fetchedUsers = [[String:String]]()
    private var results = [[String:String]]()
    
    var filteredList = [[String:String]]()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users"
        return searchBar
    }()
    private let tableView :UITableView = {
        let tableview =  UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    private let noUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users Found"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    public var returnedResult: (([String:String]) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noUsersLabel)
        searchBar.delegate =  self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dissmissController))
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.becomeFirstResponder()
        
        DatabaseManager.shared.fetchForAllUsers { result in
            switch result {
            case .success(let users):
                self.fetchedUsers = users
                print(self.fetchedUsers)
            case .failure(let error): print("🛑 faild to get users: \(error)")
            }
        }
        filteredList = fetchedUsers
    }
    
    @objc func dissmissController(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noUsersLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        noUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noUsersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        noUsersLabel.lineBreakMode = .byWordWrapping
        noUsersLabel.numberOfLines = 0
        noUsersLabel.textColor = .purple
        noUsersLabel.textAlignment = .center
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredList = fetchedUsers
        
        
        if searchText.isEmpty == false {
            filteredList = fetchedUsers.filter({ $0["name"]?.contains(searchText) as! Bool })
        }
        
        updateUI()
    }
    func updateUI(){
        if filteredList.isEmpty{
            self.noUsersLabel.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.noUsersLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

extension NewConversationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        cell.textLabel?.text = filteredList[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = filteredList[indexPath.row]
        dismiss(animated: true) {
            self.returnedResult?(selectedUser)
        }
    }
    
    
}
