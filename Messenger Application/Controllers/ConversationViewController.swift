//
//  ConversationViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
           if !isLoggedIn {
               // present login view controller
               
               let vc = LoginViewController()
               let nav = UINavigationController(rootViewController: vc)
               //full screen to not dismiss the log in screen
               nav.modalPresentationStyle = .fullScreen
               present(nav, animated: false)
           }
       }

 

}
