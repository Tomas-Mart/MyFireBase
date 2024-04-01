//
//  RegViewController.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 24.03.2024.
//

import UIKit

class RegViewController: UIViewController {
    
    private let service = Service()
    private var viewBuilder = ViewBuilder()
    private var nameField: UITextField!
    private var surNameField: UITextField!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    
    var name: String!
    var uid: String!
    
    private lazy var userDate: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.preferredDatePickerStyle = .automatic
        return $0
    }(UIDatePicker())
    
    lazy var button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Auth", for: .normal)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(regNewUser), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reg"
        view.backgroundColor = .systemGray6
        setFields()
        view.addSubview(button)
    }
    
    @objc func regNewUser() {
        guard let email = emailField.text,
              let password = passwordField.text,
              let name = nameField.text,
              let surname = surNameField.text  else {return}
        service.regNewUser(for: UserLoginData(email: email, password: password), with: UserInfo(name: name, surname: surname, date: userDate.date)) { isReg in
            if isReg {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setFields() {
        emailField = viewBuilder.createFields(placeHolder: "   Email")
        passwordField = viewBuilder.createFields(placeHolder: "   Password", isPassword: true)
        nameField = viewBuilder.createFields(placeHolder: "   Name")
        surNameField = viewBuilder.createFields(placeHolder: "   Surname")
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(nameField)
        view.addSubview(surNameField)
        view.addSubview(userDate)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -20),
            
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -20),
            
            nameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            surNameField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            surNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            userDate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            userDate.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userDate.bottomAnchor.constraint(equalTo: button.topAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
}
