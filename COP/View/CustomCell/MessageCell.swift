//
//  MessageCell.swift
//  COP
//
//  Created by Mac on 23/07/24.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var phoneNumberLabel: UILabel!
    var placeLabel: UILabel!
    var startTimeLabel: UILabel!
    var endTimeLabel: UILabel!
    
    private var backgroundviw :  UIView!
    
    private var activeLabel: UILabel!
    //    private var timeLabelsStack: UIStackView!
    
    private let backgroundShapeLayer = CAShapeLayer()
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Create name label
        
        backgroundviw = UIView()
        backgroundviw.translatesAutoresizingMaskIntoConstraints = false
        backgroundviw.backgroundColor = UIColor.systemBackground
        backgroundviw.layer.cornerRadius = 5
        backgroundviw.layer.shadowColor = UIColor.label.cgColor
        backgroundviw.layer.shadowOpacity = 0.2
        backgroundviw.layer.shadowRadius = 2
        backgroundviw.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(backgroundviw)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false // Disables autoresizing
        nameLabel.font = UIFont.systemFont(ofSize: 20) // Set desired font
        nameLabel.textColor = UIColor.label
        backgroundviw.addSubview(nameLabel)
        
        // Create phone number label
        phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 18) // Set desired font
        phoneNumberLabel.textColor = UIColor.secondaryLabel
        backgroundviw.addSubview(phoneNumberLabel)
        
        
        // Create place label
        placeLabel = UILabel()
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.font = UIFont.systemFont(ofSize: 18) // Set desired font
        placeLabel.textColor = UIColor.secondaryLabel
        backgroundviw.addSubview(placeLabel)
        
        activeLabel = UILabel()
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        activeLabel.text = "Active" // Set the text
        activeLabel.textColor = UIColor.systemBackground // Set text color to white
        activeLabel.backgroundColor = UIColor.systemGreen // Set background color to green
        activeLabel.layer.cornerRadius = 5
        activeLabel.clipsToBounds = true
        backgroundviw.addSubview(activeLabel)
        
        startTimeLabel = UILabel()
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.text = "Start Time:" // Set the text
        startTimeLabel.font = UIFont.systemFont(ofSize: 12) // Set desired font size (optional)
        startTimeLabel.textColor = UIColor.secondaryLabel
        backgroundviw.addSubview(startTimeLabel)
        
        endTimeLabel = UILabel()
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.text = "End Time:" // Set the text
        endTimeLabel.font = UIFont.systemFont(ofSize: 12) // Set desired font size (optional)
        endTimeLabel.textColor = UIColor.secondaryLabel
        backgroundviw.addSubview(endTimeLabel)
        
        setupConstraints() // Call method to define layout constraints
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = createCustomPath(in: bounds) // Replace with your custom path creation logic
        backgroundShapeLayer.path = path
    }
    
    private func createCustomPath(in rect: CGRect) -> CGPath {
        // Implement your custom path creation logic here based on the desired shape
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5) // Adjust corner radius as needed
        return path.cgPath
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundviw.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundviw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundviw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundviw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: backgroundviw.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundviw.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundviw.trailingAnchor, constant: -16),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: backgroundviw.leadingAnchor, constant: 16),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: backgroundviw.trailingAnchor, constant: -16),
            
            placeLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 8),
            placeLabel.leadingAnchor.constraint(equalTo: backgroundviw.leadingAnchor, constant: 16),
            placeLabel.trailingAnchor.constraint(equalTo: backgroundviw.trailingAnchor, constant: -16),
            
            activeLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 8),
            activeLabel.leadingAnchor.constraint(equalTo: backgroundviw.leadingAnchor, constant: 16),
            activeLabel.widthAnchor.constraint(equalToConstant: 60),
            activeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            startTimeLabel.topAnchor.constraint(equalTo: activeLabel.topAnchor),
            startTimeLabel.trailingAnchor.constraint(equalTo: backgroundviw.trailingAnchor, constant: -16),
            startTimeLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundviw.bottomAnchor, constant: -16),
            
            endTimeLabel.topAnchor.constraint(equalTo: activeLabel.bottomAnchor, constant: 8),
            endTimeLabel.trailingAnchor.constraint(equalTo: backgroundviw.trailingAnchor, constant: -16),
            endTimeLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundviw.bottomAnchor, constant: -16)
            //        contentView.bottomAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 8),
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //      fatalError("init(coder:) is not supported")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
