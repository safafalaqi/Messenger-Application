//
//  DatabaseModel.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 07/01/2022.
//

import Foundation


// MARK: - Conversation
struct Conversation {
    let id: String
    let latestMessage: LatestMessage
    let name, otherUserEmail: String
}

// MARK: - LatestMessage
struct LatestMessage {
    let date: String
    let isRead: Bool
    let message: String
}


// MARK: - Database Message
struct DatabaseMessage {
    let content, date, id: String
    let isRead: Bool
    let name, senderEmail, type: String
}

// MARK: - User
struct User {
    let email, name: String
}
