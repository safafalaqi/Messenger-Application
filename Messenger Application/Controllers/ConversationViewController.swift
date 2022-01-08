//
//  ConversationViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import AVFoundation


class ConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    let navigationBarView = UINavigationBar()
    let topView = UIView()
    var viewContainingTableView = UIView()
    private var conversations = [Conversation]()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true 
        table.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier)
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
        observeConversations()
        
      
    }
    
   
    
    @objc private func didTapComposeButton(){
        let vc = NewConversationViewController()
        vc.returnedResult = { result in
            print(result)
            self.createNewChat(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated: true)
    }
    
    
    private func createNewChat(result:[String:String]){
        guard let email = result["email"], let name = result["name"] else {return}
       //first check if curerent user already has a conversation with selected user
        let userEmail = DatabaseManager.safeEmail(email: email)
        DatabaseManager.shared.checkExistsConversation(with: userEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(_): //if no id found start a new conversation
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

        noConversationsLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        noConversationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noConversationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noConversationsLabel.translatesAutoresizingMaskIntoConstraints = false
        noConversationsLabel.lineBreakMode = .byWordWrapping
        noConversationsLabel.numberOfLines = 0
        noConversationsLabel.textColor = .purple
        noConversationsLabel.textAlignment = .center
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
        
    
    func observeConversations(){
        guard let email =  UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(email: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion:{[weak self] result in
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else{
                    return
                }
                self?.conversations = conversations
                print("success")
                DispatchQueue.main.async {
                    self?.tableView.isHidden = false
                    self?.noConversationsLabel.isHidden = true
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.noConversationsLabel.isHidden = false
                    self?.tableView.isHidden = true
                }
                print("failed: \(error)")
                
            }
        })
    }
}


extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        let data = conversations[indexPath.row]
        cell.setConversationInfo(with: data)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    // when user taps on a cell, we want to push the chat screen onto the stack
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = conversations[indexPath.row]
        let vc = ChatViewController(with: data.otherUserEmail, id: data.id)
        vc.isNewConversation = false
        vc.title = data.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}



