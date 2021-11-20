//
//  ProfileVC.swift
//  Snapchat
//
//  Created by HANAN on 05/04/1443 AH.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
class ProfileVC : UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
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
        readImageFromFirestore()
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
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        guard let d: Data = userPickedImage.jpegData(compressionQuality: 0.5) else { return }
        guard let currentUser = Auth.auth().currentUser else {return}
        
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let ref = storage.reference().child("UserProfileImages/\(currentUser.email!)/\(currentUser.uid).jpg")
        
        ref.putData(d, metadata: metadata) { (metadata, error) in
            if error == nil {
                ref.downloadURL(completion: { (url, error) in
                    self.saveImageToFirestore(url: "\(url!)", userId: currentUser.uid)
                    
                })
                DispatchQueue.main.async {
                    self.profileImage.image = userPickedImage
                }
            }else{
                print("error \(String(describing: error))")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func saveImageToFirestore(url: String, userId: String) {
        
        db.collection("Profiles").document(userId).setData([
            "userImageURL": url,
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private func readImageFromFirestore(){
        guard let currentUser = Auth.auth().currentUser else {return}
        
        db.collection("Profiles").whereField("email", isEqualTo: String(currentUser.email!))
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let imageURL = data["userImageURL"] as? String
                            {
                                
                                let httpsReference = self.storage.reference(forURL: imageURL)
                                
                                
                                httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                    if let error = error {
                                        // Uh-oh, an error occurred!
                                        print("ERROR GETTING DATA \(error.localizedDescription)")
                                    } else {
                                        // Data for "images/island.jpg" is returned
                                        
                                        DispatchQueue.main.async {
                                            self.profileImage.image = UIImage(data: data!)
                                        }
                                        
                                    }
                                }
                                
                            } else {
                                
                                print("error converting data")
                                DispatchQueue.main.async {
                                    self.profileImage.image = UIImage(systemName: "person.fill.badge.plus")
                                }
                                
                            }
                            
                            
                        }
                    }
                }
            }
    }
}




