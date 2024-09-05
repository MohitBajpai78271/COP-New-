//
//  EmptyStateView.swift
//  COP
//
//  Created by Mac on 07/08/24.
//

import UIKit

class EmptyStateView: UIView {
    
    
    var messageLabel: UILabel = {
        let message = UILabel()
        message.textColor = .secondaryLabel
        message.adjustsFontSizeToFitWidth = true
        message.minimumScaleFactor = 0.9
        message.lineBreakMode = .byTruncatingTail // at end ...
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(message: String){
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }

    private func configure(){
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
 
}
