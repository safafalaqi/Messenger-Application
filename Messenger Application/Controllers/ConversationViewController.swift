//
//  ConversationViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD


class ConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    let navigationBarView = UINavigationBar()
    let topView = UIView()
    var viewContainingTableView = UIView()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true // first fetch the conversations, if none (don't show empty convos)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //to start a new chat 
       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))

        let margins = view.layoutMarginsGuide

                view.addSubview(topView)
                topView.translatesAutoresizingMaskIntoConstraints = false
                topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                topView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                topView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
                topView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

                viewContainingTableView.layer.cornerRadius = 25
                viewContainingTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
                view.addSubview(viewContainingTableView)
                viewContainingTableView.translatesAutoresizingMaskIntoConstraints = false
                viewContainingTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
                viewContainingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                viewContainingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                viewContainingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                viewContainingTableView.backgroundColor = UIColor.white
     

                viewContainingTableView.addSubview(tableView)
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.topAnchor.constraint(equalTo: viewContainingTableView.topAnchor, constant: 20).isActive = true
                tableView.bottomAnchor.constraint(equalTo: viewContainingTableView.bottomAnchor).isActive = true
                tableView.leadingAnchor.constraint(equalTo: viewContainingTableView.leadingAnchor).isActive = true
                tableView.trailingAnchor.constraint(equalTo: viewContainingTableView.trailingAnchor).isActive = true
                
                viewContainingTableView.addSubview(noConversationsLabel)
        
    
        setupTableView()
        fetchConversations()
        
    }
    
    @objc private func didTapComposeButton(){
        // present new conversation view controller
        // present in a nav controller
        
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        //if no current user is logged in navigate to login page
        validateUser()
        
        
    }
    
    func validateUser()
    {
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            //full screen to not dismiss the log in screen
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations(){
        // fetch from firebase and either show table or label
        
        tableView.isHidden = false
    }
}


extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    // when user taps on a cell, we want to push the chat screen onto the stack
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


