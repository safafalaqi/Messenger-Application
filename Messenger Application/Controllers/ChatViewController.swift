//
//  ChatViewController.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 04/01/2022.
//

import UIKit
import InputBarAccessoryView
import MessageKit

class ChatViewController: MessagesViewController {
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter
    }()
    
    public var recipentEmail: String
    private let conversationId: String?
    public var isNewConversation = false
    
    private var messages = [Message]()
    private let selfSender:Sender? = {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        return Sender(photoURL: "", senderId: safeEmail, displayName: "Me")
    }()
    
    private var recipentAvatarURL: URL?
    private var currentAvatarURL: URL?
    
    init(with email: String, id: String?){
        self.recipentEmail = email
        self.conversationId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.purple]
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        //set attachment button
        let image = UIImage(systemName: "paperclip")!
        let button = InputBarButtonItem(frame: CGRect(origin: .zero, size: CGSize(width: image.size.width, height: image.size.height)))
        button.image = image
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .gray
        button.onTouchUpInside { [weak self] _ in
            self?.presentPhotoActionSheet()
        }
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.rightStackView.alignment = .center
        
        
        //download avatar image
        downloadAvatarImage()
    }
    
    private func observeIncomingMessages(id: String) {
            DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let messages):
                    print("success: \(messages)")
                    guard !messages.isEmpty else {
                        print("no mossages")
                        return
                    }
                    self?.messages = messages
                    
                    DispatchQueue.main.async {
                        self?.messagesCollectionView.reloadDataAndKeepOffset()
                        
                        if !strongSelf.isNewConversation {
                            self?.messagesCollectionView.scrollToLastItem()

                        }
                        
                    }
                    
                case .failure(let error):
                    print("failed to get messages: \(error)")
                }
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        
        if let conversationId = conversationId {
            observeIncomingMessages(id:conversationId)
        }
    }
   
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
                return
        }

        print("Sending: \(text)")

        let newMessage = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))

        // Send Message
        if isNewConversation {
            // create convo in database
            DatabaseManager.shared.createNewConversation(with: recipentEmail, name: self.title ?? "User", firstMessage: newMessage, completion: { [weak self]success in
                if success {
                    print("message sent")
                    self?.isNewConversation = false
                    self?.observeIncomingMessages(id: "conversation_\(newMessage.messageId)")
                    self?.messageInputBar.inputTextView.text = nil //clear text
                }
                else {
                    print("faield ot send")
                }
            })
        }
        else {
            guard let conversationId = conversationId, let name = self.title else {
                return
            }

            // append to existing conversation data
            DatabaseManager.shared.sendMessage(to:conversationId, otherUserEmail: recipentEmail ,name: name, message: newMessage, completion: { [weak self] success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    print("message sent")
                    self?.messageInputBar.inputTextView.text = nil
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
    private func createMessageId() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        return "\(recipentEmail)_\(DatabaseManager.safeEmail(email: currentUserEmail))_\(Self.dateFormatter.string(from: Date()))"
    }

}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
    }
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            if indexPath.section % 3 == 0 {
                return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
            return nil
        }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
           return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
       }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if message.sender.senderId == selfSender?.senderId{
            return NSAttributedString(string: "me", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }else{
            guard let name = self.title else {return nil}
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
               formatter.dateStyle = .medium
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }

    func currentSender() -> SenderType {
            if let sender = selfSender {
                return sender
            }
        fatalError("Self Sender is nil, email should be cached")
       
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            // our message that we've sent
            return UIColor(rgb: 0xF082DB)
        }

        return .secondarySystemBackground
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //get current user image
        if message.sender.senderId == selfSender?.senderId{
            avatarView.sd_setImage(with: currentAvatarURL, completed: nil)
        }else{
         //get recipent image
            avatarView.sd_setImage(with: recipentAvatarURL, completed: nil)
        }
        
    }
    func downloadAvatarImage(){

        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
    
        let pathForCurrentUser = "image/\(DatabaseManager.safeEmail(email: email))_profile_picture.png"
        let pathForOtherUser = "image/\(DatabaseManager.safeEmail(email: recipentEmail))_profile_picture.png"
        
        
        //current user
        StorageManager.shared.downloadURL(for: pathForCurrentUser) { [self] result in
            switch result {
            case .success(let url):
                self.currentAvatarURL = url
            case .failure(_):
                self.currentAvatarURL = nil
            }
        }
        //other user
        StorageManager.shared.downloadURL(for: pathForOtherUser) { result in
            switch result {
            case .success(let url):
                self.recipentAvatarURL = url
            case .failure(_):
                self.recipentAvatarURL = nil
            }
        }
  
    }
}
    
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
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
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
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
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage , let image = selectedImage.jpegData(compressionQuality: 0.5), let messageId = createMessageId(),let conversationId = conversationId , let name = self.title, let selfSender = selfSender else {
            print("unable to upload image to chat")
            return
        }
        
  
         let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
      //upload image to firebase and send
        StorageManager.shared.uploadConversationImage(with: image, fileName: fileName) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let url):
                print("created URL: \(url)")
                guard let urlString = URL(string: url), let placeHolder = UIImage(named: "defaultPhoto") else{
                    print("unable to upload image to firebase")
                    return
                }
                let media = ImageMediaItem(url: urlString, image: nil, placeholderImage: placeHolder, size: .zero)
                let newMessage = Message(sender: selfSender, messageId: messageId,sentDate: Date(),kind: .photo(media))
                DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.recipentEmail, name: name, message: newMessage, completion: { success in
                    if success {
                        print("sent photo message")
                    }
                    else {
                        print("failed to send photo message")
                    }

                })
            case .failure(let error):
             print("error uploading conversation image: \(error)")
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

