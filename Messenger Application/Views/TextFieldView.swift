//
//  TextFieldView.swift
//  Messenger Application
//
//  Created by Safa Falaqi on 31/12/2021.
//

import UIKit

// for styling the text filed to be underlined
class TextFieldView: UIView {
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lineView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addingSubviews()
    }
    
    func addingSubviews() {
        self.addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        self.addSubview(imgView)
        imgView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -15.0).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, constant: 0.0).isActive = true
        
        self.addSubview(textField)
        textField.lastBaselineAnchor.constraint(equalTo: imgView.lastBaselineAnchor, constant: -1.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8.0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
