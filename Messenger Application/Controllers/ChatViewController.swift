//
//  ChatViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 04/01/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    
    public var sender: SenderType // sender for each message
    public var messageId: String // id to de duplicate
    public var sentDate: Date // date time
    public var kind: MessageKind // text, photo, video, location, emoji
}
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}
// sender model
struct Sender: SenderType {
    public var photoURL: String // extend with photo URL
    public var senderId: String
    public var displayName: String
    
    
}
class ChatViewController: MessagesViewController {

//    public static var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .long
//        formatter.locale = .current
//        return formatter
//    }()
//
//    public let otherUserEmail: String
//    private let conversationId: String?
//    public var isNewConversation = false
    
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")
    
    
    
    
//    init(with email: String, id: String?) {
//        self.conversationId = id
//        self.otherUserEmail = email
//        super.init(nibName: nil, bundle: nil)
//
//        // creating a new conversation, there is no identifier
//
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init    (coder:) has not been implemented")
//    }
//
//    private var selfSender: Sender? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            // we cache the user email
//            return nil
//        }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//
//        return Sender(photoURL: "", senderId: safeEmail, displayName: "Me")
//    }
//    // will use sender's email address plus random ID generated and put into firebase
//    // photo URL, we will grab that URL once uploaded
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.purple]
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello ")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello, How are u?")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("This is a testing for the chat")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World Hello World Hello World v v Hello World Hello World Hello Worldv Hello World")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
       // messageInputBar.delegate = self
        
        
    }
}
//    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
//        DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
//            switch result {
//            case .success(let messages):
//                print("success in getting messages: \(messages)")
//                guard !messages.isEmpty else {
//                    print("messages are empty")
//                    return
//                }
//                self?.messages = messages
//
//                DispatchQueue.main.async {
//                    self?.messagesCollectionView.reloadDataAndKeepOffset()
//
//                    if shouldScrollToBottom {
//                        self?.messagesCollectionView.scrollToLastItem()
//
//                    }
//
//                }
//
//            case .failure(let error):
//                print("failed to get messages: \(error)")
//            }
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        messageInputBar.inputTextView.becomeFirstResponder()
//
//        if let conversationId = conversationId {
//            listenForMessages(id:conversationId, shouldScrollToBottom: true)
//        }
//    }
//}
//extension ChatViewController: InputBarAccessoryViewDelegate {
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = self.selfSender, let messageId = createMessageId()  else {
//            return
//        }
//
//        print("sending \(text)")
//
//        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
//
//        // Send message
//        if isNewConversation {
//            // create convo in database
//            // message ID should be a unique ID for the given message, unique for all the message
//            // use random string or random number
//            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message) { [weak self] success in
//                if success {
//                    print("message sent")
//                    self?.isNewConversation = false
//                }else{
//                    print("failed to send")
//                }
//            }
//
//        }else {
//            guard let conversationId = conversationId, let name = self.title else {
//                return
//            }
//
//            // append to existing conversation data
//            DatabaseManager.shared.sendMessage(to: conversationId, name: name, newMessage: message) { success in
//                if success {
//                    print("message sent")
//                }else {
//                    print("failed to send")
//                }
//            }
//
//        }
//
//    }
//    private func createMessageId() -> String? {
//        // date, otherUserEmail, senderEmail, randomInt possibly
//        // capital Self because its static
//
//        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
//
//        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
//
//        let dateString = Self.dateFormatter.string(from: Date())
//        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
//
//
//        print("created message id: \(newIdentifier)")
//        return newIdentifier
//
//    }
//}
    
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        // show the chat bubble on right or left?
       // if let sender = selfSender {
         //   return sender
        
        return selfSender
        //}
       // fatalError("Self sender is nil, email should be cached")
       // return Sender(photoURL: "", senderId: "12", displayName: "")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section] // message kit framework uses section to separate every single message
        // a message on screen might have mulitple pieces (cleaner to have a single section per message)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(rgb: 0xF082DB)
    }
    
    
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
