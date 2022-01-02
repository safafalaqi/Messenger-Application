//
//  ViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 29/12/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
//import JGProgressHUD


class LoginViewController: UIViewController {

    let templateColor = UIColor.white
    //private let spinner = JGProgressHUD(style: .dark)
    
    let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let bgView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        //bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
        return bgView
    }()
    
    let emailTextField : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let passwordTextfield : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    //sign in button
    let signInButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //sign up button
    let signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPassword : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fbLoginButton:FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email","public_profile"]
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        emailTextField.textField.delegate = self
        passwordTextfield.textField.delegate = self
        emailTextField.textField.tag = 1
        passwordTextfield.textField.tag = 2
        
        fbLoginButton.delegate = self
    }
    //to hide keyboard when clicking outside the text fields
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.textField.resignFirstResponder()
        passwordTextfield.textField.resignFirstResponder()
        
      
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func updateUI() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 50.0
        let textFieldViewHeight: CGFloat = 60.0
        
        // Background imageview
        self.view.addSubview(backgroundImageView)
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Background layer view
        view.insertSubview(bgView, aboveSubview: backgroundImageView)
        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Logo at top and add it above the background
        view.insertSubview(logoImageView, aboveSubview: bgView)
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, constant: 0.0).isActive = true
        
        // Email textfield and icon and add it above the background
        view.insertSubview(emailTextField, aboveSubview: bgView)
        emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        emailTextField.imgView.image = UIImage(systemName:"envelope.fill")
        let attributesDictionary = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        emailTextField.textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        emailTextField.textField.textColor = templateColor
        
        
        // Password textfield and icon
        view.insertSubview(passwordTextfield, aboveSubview: bgView)
        passwordTextfield.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0.0).isActive = true
        passwordTextfield.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        passwordTextfield.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        passwordTextfield.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, constant: 0.0).isActive = true
        
        passwordTextfield.imgView.image = UIImage(systemName: "lock.fill")
        passwordTextfield.textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        passwordTextfield.textField.isSecureTextEntry = true
        passwordTextfield.textField.textColor = templateColor
        
        // Sign In Button
        view.insertSubview(signInButton, aboveSubview: bgView)
        signInButton.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 20.0).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedString.Key.foregroundColor: templateColor]
        signInButton.alpha = 0.4
        signInButton.backgroundColor = UIColor.lightGray
        signInButton.setAttributedTitle(NSAttributedString(string: "SIGN IN", attributes: buttonAttributesDictionary), for: .normal)
        signInButton.isEnabled = true
        signInButton.addTarget(self, action: #selector(signInButtonTapped(button:)), for: .touchUpInside)
        
        //facebook sign in button
        
        view.insertSubview(fbLoginButton, aboveSubview: bgView)
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        fbLoginButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20.0).isActive = true
        fbLoginButton.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor, constant: 0.0).isActive = true
        fbLoginButton.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: 0.0).isActive = true
        fbLoginButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        
        
        // Forgot Password Button
        view.insertSubview(forgotPassword, aboveSubview: bgView)
        forgotPassword.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 20.0).isActive = true
        forgotPassword.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        forgotPassword.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        
        forgotPassword.setTitle("Forgot password?", for: .normal)
        forgotPassword.setTitleColor(templateColor, for: .normal)
        forgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        forgotPassword.addTarget(self, action: #selector(forgotPasswordButtonTapped(button:)), for: .touchUpInside)
        
        // sign Up Button
        view.insertSubview(signUpButton, aboveSubview: bgView)
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10.0).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(button:)), for: .touchUpInside)
        
        let text = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let detailAttributes = [ NSAttributedString.Key.foregroundColor : templateColor,
                                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0) ,NSAttributedString.Key.paragraphStyle : style]
        
        attributedString.addAttributes(detailAttributes, range: NSMakeRange(0, attributedString.length))
        
        
        let sampleLinkRange1 = text.range(of: "Sign Up")!
        let startPos1 = text.distance(from: text.startIndex, to: sampleLinkRange1.lowerBound)
        let endPos1 = text.distance(from: text.startIndex, to: sampleLinkRange1.upperBound)
        let linkRange1 = NSMakeRange(startPos1, endPos1 - startPos1)
        let linkAttributes1 = [ NSAttributedString.Key.foregroundColor : templateColor,
                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0)]
        
        attributedString.addAttributes(linkAttributes1, range: linkRange1)
        
        signUpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @objc private func signInButtonTapped(button: UIButton) {
        guard let email = emailTextField.textField.text,
              let password = passwordTextfield.textField.text,
              !email.isEmpty,
              !password.isEmpty else{
                  showAlertVC(title: "Enter a correct email and password")
                  return}
        
        // Firebase Login weak self to avoid retention cycle
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self]  authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(email)")
                strongSelf.showAlertVC(title: "Enter a correct email and password")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @objc private func signUpButtonTapped(button: UIButton) {
        
        //navigate to sign up page
        let vc = RegisterViewController()
        vc.title =  "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func forgotPasswordButtonTapped(button: UIButton) {
        
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            signInButtonTapped(button: signInButton)
        }
        return false
    }
}


//facebook LoginButtonDelegate
//https://developers.facebook.com/docs/reference/ios/current/protocol/FBSDKLoginButtonDelegate
extension LoginViewController: LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard let token = result?.token?.tokenString else {
            print("🔵Failed to login with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "/me",parameters: ["fields": "email, first_name, last_name"],tokenString: token, version: nil,httpMethod: .get)
        
        facebookRequest.start (completion: {connection , result, error in
            guard let result = result as? [String:Any] , error == nil else {
                print("🔴failed to make graph request  - \(error)")
                
                return
            }
            print("🟢\(result)")
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String
            else{
                print("🔴failed to get email and name")
                return
            }
            //we need to add them to the real database but first check if exists
            DatabaseManger.shared.userExists(with: email, completion:{exists in
                if !exists{
                    DatabaseManger.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            })
            
            
            //we get the crediential from facebook and pass them to firebase
            let crediential = FacebookAuthProvider.credential(withAccessToken: token)
            
            
            // now after obtaining the credinetial we pass it to firebase
            FirebaseAuth.Auth.auth().signIn(with:crediential , completion: { [weak self] authResult ,  error in
                guard let strongSelf = self else {
                    return
                    
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error{
                        print("🔴Facebook log in failed  - \(error)")
                        
                    }
                    return
                }
                
                print("🟢Successufly loged in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
            
        })
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no need to implement
    }
    
    
}
