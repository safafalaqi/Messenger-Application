//
//  ConversationViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        
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
 

}
