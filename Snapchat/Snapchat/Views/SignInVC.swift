//
//  SignInVC.swift
//  Snapchat
//
//  Created by HANAN on 04/04/1443 AH.
//

// 22 DEC
import UIKit
class SignInVC: UIViewController {
    
    
    //MARK: Step 1
    lazy var titlelbl: UILabel               = {
        $0.changeUILabel(title: "SIGN IN", size: 20)
        return $0
    }(UILabel())
    
    lazy var singInBtn : UIButton            = {
        $0.changeUIButton(title: "Sign in ", color: colors.button)
        $0.addTarget(self, action:#selector(PresssignUpButton), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    lazy var signUpBtn : UIButton            = {
        $0.changeUIButton(title: "Don't have an account? Sign up", color: .clear)
        $0.addTarget(self, action:#selector(didPresssignUpButton), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    lazy var emailTextFiled :  ViewController    = {
        $0.textFiled.placeholder             = "Email"
        $0.icon.image                        = UIImage(named: "email")
        return $0
    }(ViewController())
    
    lazy var passwordTextFiled : ViewController  = {
        $0.textFiled.placeholder             = "Password"
        $0.icon.image                        = UIImage(named: "password")
        return $0
    }(ViewController())
    
    
    lazy var stack : UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        //
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradiantView()
        print("good move ")
        //MARK: Step 2
        self.view.addSubview(titlelbl)
        self.view.addSubview(signUpBtn)
        self.view.addSubview(singInBtn)
        // crach
        self.view.addSubview(stack)
        self.stack.addArrangedSubview(emailTextFiled)
        self.stack.addArrangedSubview(passwordTextFiled)
        //emailTextFiled.textFiled.placeholder = "Email"
       // passwordTextFiled.textFiled.placeholder = "Password"
        
        //MARK: step 3
        NSLayoutConstraint.activate([
            //***
            self.titlelbl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            self.titlelbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            //***
            self.stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stack.topAnchor.constraint(equalTo: self.titlelbl.bottomAnchor, constant: 20),
            self.stack.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -100),

            //singInBtn BTN
            self.singInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.singInBtn.topAnchor.constraint(equalTo: self.stack.bottomAnchor, constant: 20),
            self.singInBtn.heightAnchor.constraint(equalToConstant: 50),
            //frame
            self.singInBtn.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.2),
            //signUpBtn BTN
            self.signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signUpBtn.topAnchor.constraint(equalTo: self.singInBtn.bottomAnchor, constant: 5),
            self.signUpBtn.heightAnchor.constraint(equalToConstant: 30),
            // ffframe
            self.signUpBtn.widthAnchor.constraint(equalToConstant: self.view.frame.width),
        ])
        
    }
    
    @objc func didPresssignUpButton(_ sender: UIButton){
        let VC = SignUpVC()
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
        print("move")
        
        
    }
    @objc func PresssignUpButton(_ sender: UIButton){
        let vc = TabBarVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        print("move")

}
}
