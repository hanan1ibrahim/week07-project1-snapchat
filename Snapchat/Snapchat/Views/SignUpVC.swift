//
//  SignUpVC.swift
//  Snapchat
//
//  Created by HANAN on 04/04/1443 AH.
//

import UIKit

class SignUpVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        // MARK: variables
    lazy var titleLbl: UILabel = {
             $0.changeUILabel(title: "SignUp", size: 20)
             return $0
         }(UILabel())
    
    lazy var singUpBtn: UIButton = {
        $0.changeUIButton(title: "Sign Up", color: colors.button)
            
                return $0
        //             signUpButton.addTarget(self, action:#selector(didPresssignUpButton), for: .touchUpInside)
        
    }(UIButton(type: .system))
    
    lazy var singInBtn: UIButton = {
        $0.changeUIButton(title: "Do you have an account? Sign in", color: .clear)
        $0.addTarget(self, action:#selector(didPresssignInButton), for: .touchUpInside)
              
        return $0
    }(UIButton(type: .system))
    
    
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
        let image = info[.editedImage] ?? info [.originalImage] as? UIImage
         profileImage.image = image as? UIImage
           imagePicker.dismiss(animated: true, completion: nil)
       }
      }

   

