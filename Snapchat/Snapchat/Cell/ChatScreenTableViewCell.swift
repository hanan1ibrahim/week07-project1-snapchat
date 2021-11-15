//
//  ChatScreenTableViewCell.swift
//  Snapchat
//
//  Created by Kholod Sultan on 10/04/1443 AH.
//

import UIKit

class ChatScreenTableViewCell: UITableViewCell {

    static let cellId = "12345"

    let userNameLabel: UILabel = {
       let name = UILabel()
        
        name.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        name.textAlignment = .left
        name.textColor = .black
        
        return name
    }()

    let userEmail: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        name.textAlignment = .left
        name.textColor = UIColor.secondaryLabel
        return name
    }()

    let circleImage: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 9, weight: .bold, scale: .medium))
        return img
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    func setupViews() {

        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userNameLabel)
        userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true

        circleImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleImage)
        circleImage.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 0).isActive = true
        circleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
       
        
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userEmail)
        userEmail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        userEmail.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).isActive = true
        
        
    }
    
   

}



