//
//  AuthViewController.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 24.03.2024.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var viewBuilder = ViewBuilder()
    private let service = Service()
    private let mainVC = ViewController()
    private var emailField: UITextField!
    private var passwordField: UITextField!
    var delegate: SceneRoutingDelegate?
    
    private lazy var signInButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Auth", for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var signOutButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Sign", for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth"
        view.backgroundColor = .systemGray6
        setFields()
    }
    
    @objc func signOut() {
        let vc = RegViewController()
        vc.name = "Amina"
        vc.uid = "cyB7zpeWyufigkRa8aES"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signIn() {
        guard let email = emailField.text, let password = passwordField.text else {return}
        service.signIn(for: UserLoginData(email: email, password: password)) { isLogin in
            if isLogin {
                self.delegate?.vcRouting(vc: self.mainVC)
            }
        }
    }
    
    private func setFields() {
        emailField = viewBuilder.createFields(placeHolder: "   Email")
        passwordField = viewBuilder.createFields(placeHolder: "   Password", isPassword: true)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signInButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
    
    
}

class ViewBuilder {
    
    func createFields(placeHolder: String, isPassword: Bool = false) -> UITextField {
        let field = UITextField()
        field.isSecureTextEntry = isPassword
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.placeholder = placeHolder
        field.backgroundColor = .white
        return field
    }
}
