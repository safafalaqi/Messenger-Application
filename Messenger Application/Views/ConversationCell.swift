//
//  ConversationCell.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 07/01/2022.
//

import UIKit
import SDWebImage

class ConversationCell: UITableViewCell {
    static let identifier = "conversationCell"
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "defaultImage")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.gray.cgColor
        img.clipsToBounds = true
        return img
    }()
    var dateLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.text = "09:00AM"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    var nameLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "name"
        label.textColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profileImageView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        self.contentView.addSubview(containerView)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:20).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        
        messageLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setConversationInfo(with data:Conversation){
   
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let date = dateFormatter.date(from: data.latestMessage.date)
        dateLabel.text = date?.toString(format: "h:mm a")
        nameLabel.text = data.name
        messageLabel.text = data.latestMessage.message
        StorageManager.shared.downloadURL(for: "image/\(data.otherUserEmail)_profile_picture.png", completion: { [weak self] result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.profileImageView.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        })
    }
    
}

extension Date {

    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
