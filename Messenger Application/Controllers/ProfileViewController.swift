//
//  ProfileViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

class ProfileViewController: UIViewController {
    
    var data = ["","","Log Out"] // of type profile
    @IBOutlet weak var tableView: UITableView!
    
    let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource =  self
        tableView.backgroundColor = .clear
    
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let name = UserDefaults.standard.value(forKey: "name") as? String {
            data[0] = name
            data[1] = email
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.tableHeaderView = setHeader()
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let name = UserDefaults.standard.value(forKey: "name") as? String {
            data[0] = name
            data[1] = email
        }
        tableView.reloadData()
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    
    func setHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "image/" + filename
        let headerView = UIView(frame: CGRect(x: 0,y: 0,  width: self.tableView.frame.width,height: 300))
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.width - 150)/2, y: 75, width: 150, height: 150 ))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        StorageManager.shared.downloadURL(for: path) { result in
            switch result{
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("here the error \(error)")
                //in case if fail to upload the image display difault image
                imageView.image = UIImage(named: "defaultImage.png")
            }
        }
        
        return headerView
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        if indexPath.row == 0{
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
        }else if indexPath.row == 1{
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        }else{
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
        }
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //if log out pressed
        if indexPath.row == 2{
        let alert = UIAlertController(title: "", message: "Are you sure you want to log out ?", preferredStyle: UIAlertController.Style.actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self]
            _ in
            
            guard let strongSelf = self else {
                return
            }
            
            //handle when user is online or not
            guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {return}
            let safeEmail = DatabaseManager.safeEmail(email: currentEmail)
            DatabaseManager.shared.userIsOffline(for: safeEmail){ (success) in
            //print("User sign out ==>", success)
            }

            
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "name")
        
            //log out from facebook session
            FBSDKLoginKit.LoginManager().logOut()
            //google sign out
            GIDSignIn.sharedInstance.signOut()
           
            do{
                try FirebaseAuth.Auth.auth().signOut()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav,animated: true)
                }
            }catch{
                print("faild")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
}
