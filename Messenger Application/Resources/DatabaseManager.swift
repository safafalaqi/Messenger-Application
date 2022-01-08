//
//  DatabaseManger.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 01/01/2022.
//

import Foundation
import FirebaseDatabase
import UIKit
import MessageKit
// singleton creation below
// final - cannot be subclassedcopy
final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    // reference the database below
    private let database = Database.database().reference()
    
    //to use for downloading images
    static func safeEmail(email: String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
// MARK: - account management
extension DatabaseManager {
    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        let safeEmail = DatabaseManager.safeEmail(email: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    //it will return a result of users collection
    public func fetchForAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    // Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue(["first_name": user.firstName, "last_name": user.lastName], withCompletionBlock: { [weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                print("failed ot insert user into database")
                completion(false)
                return
            }
            //add user to the list of users in database
            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersList = snapshot.value as? [[String: String]] {
                    let newElement = [ "name": user.firstName + " " + user.lastName, "email": user.safeEmail   ]
                    usersList.append(newElement)
                    strongSelf.database.child("users").setValue(usersList, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
                else {
                    // create a new list
                    let newList: [[String: String]] = [[ "name": user.firstName + " " + user.lastName, "email": user.safeEmail]]
                    strongSelf.database.child("users").setValue(newList, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getCurrentUserName(email:String,completion: @escaping (Result<Any, Error>) -> Void){
        database.child("\(email)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}
public enum DatabaseError: Error {
    case failedToFetch
}


// MARK: - Sending messages and Conversations
extension DatabaseManager {
    
    public func createNewConversation(with otherUserEmail: String ,name : String,  firstMessage:Message, completion: @escaping (Bool) -> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String
        else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: currentEmail) // cant have certain characters as keys
        
        //we have to check if conversation exists
        let ref = database.child(safeEmail)
        ref.observeSingleEvent(of: .value, with:{snapshot in
            guard var userNode = snapshot.value as? [String: Any] else{
                completion(false)
                print("user not  dound")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            let message = self.getMessageType(message: firstMessage.kind)
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "name": name,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            // Update recipient conversaiton entry
            self.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversatoins = snapshot.value as? [[String: Any]] {
                    // append
                    conversatoins.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversatoins)
                }
                else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })
            
            
            if var conversations = userNode["conversations"] as? [[String:Any]]{
                //if exists
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode ,withCompletionBlock: {error, _ in
                    guard error == nil else {
                        completion(false)
                        print("unable to start conversation ")
                        return
                    }
                    self.finishCreatingConversation(conversationID: conversationId, name: name, firstMessage: firstMessage, completion: completion)
                })
                
            }else{
                //otherwise create a new conversation
                userNode["conversations"] = [newConversationData]
                ref.setValue(userNode ,withCompletionBlock: {error, _ in
                    guard error == nil else {
                        completion(false)
                        print("unable to start conversation ")
                        return
                    }
                    self.finishCreatingConversation(conversationID: conversationId, name: name, firstMessage: firstMessage, completion: completion)
                    
                })
            }
        })
    }
    //when user click compose message , the app must check if user already has a conversation with selected
    //completion will return the conversationId
    public func checkExistsConversation(with recipentEmail:String, completion:@escaping (Result<String, Error>) -> Void){
        let reciverEmail = DatabaseManager.safeEmail(email: recipentEmail)
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let senderEmail = DatabaseManager.safeEmail(email: email)
        database.child("\(reciverEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
            guard let converstaionList = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            for conversation in converstaionList{
                
                if conversation["other_user_email"] as! String == senderEmail{
                    
                    completion(.success(conversation["id"] as! String))
                    return
                }
                
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
        
        
    }
    //get type of current message
    private func getMessageType(message: MessageKind) -> String {
        switch message{
        case .text(let messageText):
            return messageText
        case .attributedText(_):
            break
        case .photo(let mediaItem):
            if let imageUrl = mediaItem.url?.absoluteString {
                return imageUrl
            }
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        return ""
    }
    
    //
    private func finishCreatingConversation(conversationID:String ,name: String,firstMessage: Message, completion: @escaping (Bool) -> Void){
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        let message = self.getMessageType(message: firstMessage.kind)
        
        guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        let currentEmail = DatabaseManager.safeEmail(email: userEmail)
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentEmail,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        print(conversationID)
        database.child("\(conversationID)").setValue(value, withCompletionBlock: {error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    //get all conversations from firebase
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void){
        // a listener for all conversations
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]]else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                          return nil
                      }
                
                let latestMmessageObject = LatestMessage(date: date,isRead: isRead,message: message)
                
                return Conversation(id: conversationId,
                                    latestMessage: latestMmessageObject,
                                    name: name,
                                    otherUserEmail: otherUserEmail )
            })
            completion(.success(conversations))
        })
    }
    
    //get all messages for the current conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void){
        database.child("\(id)/messages").observe(.value) { snapshot in
            // new conversation created? we get a completion handler called
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let messages: [Message] = value.compactMap { dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString)
                else {
                    return nil
                }
                var mType: MessageKind?
                if type == "photo"{
                    guard let url = URL(string: content), let plaecHolder = UIImage(named: "defaultPhoto") else{
                        return nil
                    }
                    mType = .photo(ImageMediaItem(url: url, image: nil, placeholderImage: plaecHolder, size: CGSize(width: 300, height: 300)))
                }else{
                    mType = .text(content)
                }
                guard let messageType = mType else {
                    return nil
                }
                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageID, sentDate: date, kind: messageType )
            }
            completion(.success(messages))
            
        }
    }
    
    public func sendMessage(to conversation: String,otherUserEmail:String,name: String, message:Message, completion: @escaping (Bool) -> Void){
        
        guard let userEmail = UserDefaults.standard.value(forKey: "email") as? String else{
            completion(false)
            return
        }
        self.database.child("\(conversation)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            
            guard let strongSelf = self else {
                return
            }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            let messageDate = message.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            let m = strongSelf.getMessageType(message: message.kind)
            
            let currentUserEmail = DatabaseManager.safeEmail(email: userEmail)
            
            let newMessageEntry: [String: Any] = [
                "id": message.messageId,
                "type": message.kind.messageKindString,
                "content": m,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name,
            ]
            
            currentMessages.append(newMessageEntry)
            
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                strongSelf.database.child("\(currentUserEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                    guard var currentConversations = snapshot.value as? [[String:Any]] else{
                        completion(false)
                        return
                    }
                    
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": m
                    ]
                    
                    var targetConversation: [String: Any]?
                    var position = 0
                    
                    for conversationDictionary in currentConversations {
                        if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                            targetConversation = conversationDictionary
                            break
                        }
                        position += 1
                    }
                    
                    
                    targetConversation?["latest_message"] = updatedValue
                    guard let finalConversation = targetConversation else{
                        completion(false)
                        return
                    }
                    //update for current user
                    currentConversations[position] = finalConversation
                    strongSelf.database.child("\(currentUserEmail)/conversations").setValue(currentConversations, withCompletionBlock: { error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                    })
                    
                    
                })
                
                //update for other user
                strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                    guard var otherConversations = snapshot.value as? [[String:Any]] else{
                        completion(false)
                        return
                    }
                    
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": m
                    ]
                    
                    var targetConversation: [String: Any]?
                    var position = 0
                    
                    for conversationDictionary in otherConversations {
                        if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                            targetConversation = conversationDictionary
                            break
                        }
                        position += 1
                    }
                    
                    
                    targetConversation?["latest_message"] = updatedValue
                    guard let finalConversation = targetConversation else{
                        completion(false)
                        return
                    }
                    //update for current user
                    otherConversations[position] = finalConversation
                    strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherConversations, withCompletionBlock: { error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                    
                })
                
            }
            
        }
        
    }
    
}
