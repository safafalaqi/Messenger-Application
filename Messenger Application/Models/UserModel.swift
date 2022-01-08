//
//  UserModel.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 08/01/2022.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePictureUrl: String
    
    // create a computed property safe email
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String{
        return "\(safeEmail)_profile_picture.png"
    }
}
