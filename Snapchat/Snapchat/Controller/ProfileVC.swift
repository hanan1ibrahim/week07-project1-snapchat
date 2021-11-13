//
//  ProfileVC.swift
//  Snapchat
//
//  Created by HANAN on 05/04/1443 AH.
//

import Foundation
import UIKit

class ProfileVC : UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
        
        lazy var containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 20
            return view
        }()
        
        //image picker
        lazy var profileImage: UIImageView = {
           let view = UIImageView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.backgroundColor = UIColor(red: (50/255), green: (179/255), blue: (168/255), alpha: 1)
           view.layer.cornerRadius = 25
            view.isUserInteractionEnabled = true
                                  
           return view
       }()
        lazy var imagePicker : UIImagePickerController = {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = true
           
           return imagePicker
       }()
        //user name
        lazy var nameLabel: UITextField = {
           let label = UITextField()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Nuna"
           return label
       }()
        lazy var usernameStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .horizontal
            view.spacing = 16
            return view
        }()
        
        lazy var userStatusLabel: UITextField = {
            let label = UITextField()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "i'm happy"
            return label
        }()
        lazy var saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save Snapcode", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 250).isActive = true
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.backgroundColor = .black
            return button
        }()
        lazy var shareButton: UIButton = {
            let button = UIButton (type: .system)
            button.setTitle("ShareURL", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 250).isActive = true
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.backgroundColor = .black

            return button
        }()
        lazy var cancelButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Cancel", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont (forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 250).isActive = true
            button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            return button
        }()
        lazy var verticalStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .equalSpacing
            return view
        }()
        
        override func viewDidLoad () {
            super.viewDidLoad()
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
             profileImage.addGestureRecognizer(tapRecognizer)
            
            view.backgroundColor = .white
       
            view.addSubview(containerView)
            containerView.addSubview (verticalStackView)
            verticalStackView.addArrangedSubview(profileImage)
            verticalStackView.addArrangedSubview (nameLabel)
            verticalStackView.addArrangedSubview(usernameStackView)
            usernameStackView.addArrangedSubview (userStatusLabel)
            verticalStackView.addArrangedSubview(saveButton)
            verticalStackView.addArrangedSubview(shareButton)
            verticalStackView.addArrangedSubview(cancelButton)
            
            NSLayoutConstraint.activate([
        containerView.heightAnchor.constraint(equalToConstant: 500),
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        containerView.leadingAnchor.constraint (equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 6),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: containerView.trailingAnchor, multiplier: 6),
        verticalStackView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 2),
        verticalStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 6),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: verticalStackView.trailingAnchor, multiplier: 6),
                containerView.bottomAnchor.constraint (equalToSystemSpacingBelow: verticalStackView.bottomAnchor, multiplier: 3),
                profileImage.heightAnchor.constraint (equalToConstant: 200),
                profileImage.widthAnchor.constraint(equalToConstant: 200),
            ])
     
            }
        @objc private func cancelButtonTapped() {
        present(TabBarVC(), animated: true, completion: nil)
            }
        
          @objc func imageTapped() {
            print("Image tapped")
            present(imagePicker, animated: true)
          }
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.editedImage] ?? info [.originalImage] as? UIImage
              profileImage.image = image as? UIImage
            dismiss(animated: true)
          }
        }

    
    

