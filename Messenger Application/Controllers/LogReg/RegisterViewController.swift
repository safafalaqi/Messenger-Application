//
//  RegisterViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 30/12/2021.
//

import UIKit
import FirebaseAuth
//import JGProgressHUD

class RegisterViewController: UIViewController {

    let templateColor = UIColor.white
   // private let spinner = JGProgressHUD(style: .dark)
    
    let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let accountImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        //imageView.layer.masksToBounds = true
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let bgView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView
    }()
    
    let firstName : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let lastName : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
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
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        accountImage.addGestureRecognizer(gesture)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

        //to move the cursor to next field
        firstName.textField.delegate = self
        lastName.textField.delegate = self
        emailTextField.textField.delegate = self
        passwordTextfield.textField.delegate = self

        firstName.textField.tag = 1
        lastName.textField.tag = 2
        emailTextField.textField.tag = 3
        passwordTextfield.textField.tag = 4
     
    }
    //to hide keyboard when clicking outside the text fields
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        firstName.textField.resignFirstResponder()
        lastName.textField.resignFirstResponder()
        emailTextField.textField.resignFirstResponder()
        passwordTextfield.textField.resignFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        accountImage.layer.cornerRadius = accountImage.frame.size.width / 2
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
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
        view.insertSubview(accountImage, aboveSubview: bgView)
        accountImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        accountImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        accountImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        accountImage.widthAnchor.constraint(equalTo: accountImage.heightAnchor, constant: 0.0).isActive = true
        accountImage.isUserInteractionEnabled = true
        accountImage.tintColor = templateColor
       

        
        // First Name
        view.insertSubview(firstName, aboveSubview: bgView)
        firstName.topAnchor.constraint(equalTo: accountImage.bottomAnchor, constant: 20.0).isActive = true
        firstName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        firstName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        firstName.imgView.image = UIImage(systemName:"person.crop.circle")
        let attributesDictionary = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        firstName.textField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: attributesDictionary)
        firstName.textField.textColor = templateColor
        
        
        
        // Last Name add it above the background
        view.insertSubview(lastName, aboveSubview: bgView)
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 10.0).isActive = true
        lastName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        lastName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        lastName.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        lastName.imgView.image = UIImage(systemName:"person.crop.circle")
        lastName.textField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: attributesDictionary)
        lastName.textField.textColor = templateColor
        
        
        
        // Email textfield and icon and add it above the background
        view.insertSubview(emailTextField, aboveSubview: bgView)
        emailTextField.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 10.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        emailTextField.imgView.image = UIImage(systemName:"envelope.fill")
        emailTextField.textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        emailTextField.textField.textColor = templateColor
 
        
        // Password textfield and icon
        view.insertSubview(passwordTextfield, aboveSubview: bgView)
        passwordTextfield.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwordTextfield.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        passwordTextfield.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        passwordTextfield.heightAnchor.constraint(equalTo: emailTextField.heightAnchor, constant: 0.0).isActive = true
        
        passwordTextfield.imgView.image = UIImage(systemName: "lock.fill")
        passwordTextfield.textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        passwordTextfield.textField.isSecureTextEntry = true
        passwordTextfield.textField.textColor = templateColor
        
        // Sign In Button
        view.insertSubview(registerButton, aboveSubview: bgView)
        registerButton.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 10.0).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0.0).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0.0).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedString.Key.foregroundColor: templateColor]
        registerButton.alpha = 0.4
        registerButton.backgroundColor = UIColor.lightGray
        registerButton.setAttributedTitle(NSAttributedString(string: "SIGN IN", attributes: buttonAttributesDictionary), for: .normal)
        registerButton.isEnabled = true
        registerButton.addTarget(self, action: #selector(registerButtonTapped(button:)), for: .touchUpInside)
        
    
    }
    
    @objc private func registerButtonTapped(button: UIButton) {
        guard let fName = firstName.textField.text,
              let lName = lastName.textField.text,
              let email = emailTextField.textField.text,
              let password = passwordTextfield.textField.text,
              !fName.isEmpty,
              !lName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else{ return}
        
        //before creating a new user  make sure user with same email doesnot exisit
        DatabaseManager.shared.userExists(with: email, completion:{ exists in
            //check if ex is nil
            guard !exists else{
                //user exists
                self.showAlertVC(message: "User is already exists")
                return
            }
        })
        
        //create an account in Firebase
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self]  authResult , error  in
            guard let strongSelf = self else {
                   return
               }
            guard authResult != nil, error == nil else {
                print("Error creating user")
                
                return
            }
        
            //before dissmising add to the database the first name and the last name
            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: fName , lastName: lName, emailAddress: email))
            
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })

    }
    
    func showAlertVC(message: String = "Enter all required information") {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.accountImage.image = selectedImage
        self.accountImage.contentMode = .scaleAspectFill
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
            } else {
                registerButtonTapped(button: registerButton)
            }
        return false
    }
}
