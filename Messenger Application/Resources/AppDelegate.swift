//
//  AppDelegate.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 29/12/2021.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var signInConfig: GIDConfiguration?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user = user, error == nil {
                self?.handleGoogleSession(user: user)
            }
        }
        
        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }

        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }
    
    
    
    func handleGoogleSession(user: GIDGoogleUser) {
        guard let email = user.profile?.email,
              let firstName = user.profile?.givenName,
              let lastName = user.profile?.familyName else {
                  return
              }
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // insert to database
                let chatUser = ChatAppUser(
                    firstName: firstName,
                    lastName: lastName,
                    emailAddress: email
                    
                )
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success {
                        
                        if ((user.profile?.hasImage) != nil){
                            guard let url = user.profile?.imageURL(withDimension: 200) else {
                                return
                            }
                            URLSession.shared.dataTask(with: url) { data, _ , _ in
                                guard let data = data else {
                                    return
                                }
                                //upload user image in here
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                    switch result{
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error): print(error)
                                    }
                                }
                            }.resume()
                            
                        }
                        
                    }
                }
            }})
        
        
        let authentication = user.authentication
        guard let idToken = authentication.idToken else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: authentication.accessToken
        )
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }
            
            print("Successfully signed in with Google cred. \(email)")
            NotificationCenter.default.post(name: Notification.Name("didLogIn"), object: nil)
        })
    }
}
