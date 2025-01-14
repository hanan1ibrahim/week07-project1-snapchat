//
//  SignUpVC.swift
//  Snapchat
//
//  Created by HANAN on 04/04/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var userName:String = ""
    var emailAddress:String = ""
    var password:String = ""
    var birthday:String = ""
    let storage = Storage.storage()
    let db = Firestore.firestore()

    
    // MARK: variables
    lazy var titleLbl: UILabel = {
        $0.changeUILabel(title: "SignUp", size: 20)
        return $0
    }(UILabel())
    
    
    lazy var singUpBtn: UIButton = {
        $0.changeUIButton(title: "Sign Up", color: colors.button)
        $0.addTarget(self, action:#selector(startSignUp), for: .touchUpInside)
        
        return $0
        //             signUpButton.addTarget(self, action:#selector(didPresssignUpButton), for: .touchUpInside)
    }(UIButton(type: .system))
    
    lazy var singInBtn: UIButton = {
        $0.changeUIButton(title: "Do you have an account? Sign in", color: .clear)
        $0.addTarget(self, action:#selector(didPresssignInButton), for: .touchUpInside)
        
        return $0
    }(UIButton(type: .system))
    
    @objc func startSignUp() {
        self.userName = self.nameTextFiled.textFiled.text ?? ""
        self.emailAddress = self.emailTextFiled.textFiled.text ?? ""
        self.password = self.passwordTextFiled.textFiled.text ?? ""
        self.birthday = self.birthdayTextFiled.textFiled.text ?? ""
        Auth.auth().createUser(withEmail: self.emailAddress, password: self.password) { result, error in
            if error != nil {
                print(error as Any)
                return
            }else{
                guard let user = result?.user else {return}
                
                self.db.collection("Profiles").document(user.uid).setData([
                    "name": self.userName,
                    "email": String(user.email!),
                    "userID": user.uid,
                    "status": "yes",
                    "birthday": self.birthday
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        guard let d: Data = self.profileImage.image?.jpegData(compressionQuality: 0.5) else { return }
                        guard let currentUser = Auth.auth().currentUser else {return}
                        
                        
                        
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/png"
                        
                        let ref = self.storage.reference().child("UserProfileImages/\(currentUser.email!)/\(currentUser.uid).jpg")
                        
                        ref.putData(d, metadata: metadata) { (metadata, error) in
                            if error == nil {
                                ref.downloadURL(completion: { (url, error) in
                                    self.saveImageToFirestore(url: "\(url!)", userId: currentUser.uid)
                                    
                                })
                            }else{
                                print("error \(String(describing: error))")
                            }
                        }
                    }
                }
            }
        }
    }
    lazy var profileImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
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
    lazy var nameTextFiled: ViewController = {
        $0.textFiled.placeholder = "User Name"
        $0.icon.image = UIImage(named: "user")
        return $0
    }(ViewController())
    
    lazy var emailTextFiled:ViewController = {
        $0.textFiled.placeholder = "Email"
        $0.icon.image = UIImage(named: "email")
        return $0
    }(ViewController())
    lazy var passwordTextFiled: ViewController = {
        $0.textFiled.placeholder = "Password"
        $0.icon.image = UIImage(named: "password")
        return $0
    }(ViewController())
    lazy var birthdayTextFiled: ViewController = {
        $0.textFiled.placeholder = "Birthday"
        $0.icon.image = UIImage(named: "birthday")
        return $0
    }(ViewController())
    
    lazy var stackView : UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(tapRecognizer)
        view.setGradiantView()
        
        view.addSubview(titleLbl)
        view.addSubview(singInBtn)
        view.addSubview(singUpBtn)
        view.addSubview(profileImage)
        //stack
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameTextFiled)
        stackView.addArrangedSubview(emailTextFiled)
        stackView.addArrangedSubview(passwordTextFiled)
        stackView.addArrangedSubview(birthdayTextFiled)
        
        NSLayoutConstraint.activate([
            
            self.titleLbl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            self.titleLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant:200),
            self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -80),
            
            
            self.emailTextFiled.heightAnchor.constraint(equalToConstant: 50),
            self.passwordTextFiled.heightAnchor.constraint(equalToConstant: 50),
            self.emailTextFiled.heightAnchor.constraint(equalToConstant: 50),
            self.birthdayTextFiled.heightAnchor.constraint(equalToConstant: 50),
            
            
            self.singUpBtn.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 30),
            self.singUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.singUpBtn.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.2),
            self.singUpBtn.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            self.singInBtn.topAnchor.constraint(equalTo: self.singUpBtn.bottomAnchor, constant: 5),
            self.singInBtn.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.singInBtn.heightAnchor.constraint(equalToConstant: 30),
            self.singInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            //Constraint profileImage
            
            profileImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -145),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
        ])

    }
    
    @objc func didPresssignInButton(_ sender : UIButton ){
        let VC = SignInVC()
        VC.modalPresentationStyle = .fullScreen
        
        
        // use dismiss NOT present to avoid load memory.
        dismiss(animated: true, completion: nil)
        print("move")
        
    }
    
    //image picker
    @objc func imageTapped() {
        print("Image tapped")
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profileImage.image = userPickedImage
        
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
                let vc = TabBarVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    

    
    
    
}
