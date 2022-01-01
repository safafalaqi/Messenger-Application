//
//  ViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 29/12/2021.
//

import UIKit
//import FirebaseAuth
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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
        
        // Forgot Password Button
        view.insertSubview(forgotPassword, aboveSubview: bgView)
        forgotPassword.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 0.0).isActive = true
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
        showAlertVC(title: "Sign In tapped")
    }
    
    @objc private func signUpButtonTapped(button: UIButton) {
        //showAlertVC(title: "Sign up tapped")
        //navigate to sign up page
        
        let vc = RegisterViewController()
        vc.title =  "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func forgotPasswordButtonTapped(button: UIButton) {
        showAlertVC(title: "Forgot password tapped")
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "Need to implement code based on user requirements", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
}



