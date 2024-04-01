//
//  AddViewController.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 22.03.2024.
//

import UIKit
import Firebase


class AddViewController: UIViewController {
    
    private let service = Service()
    
    lazy var titleField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Title"
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.textAlignment = .center
        return $0
    }(UITextField())
    
    lazy var textView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UITextView())
    
    lazy var button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
            let vc = MapViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        title = "Add new note"
        view.backgroundColor = .systemGray6
        addSubViews()
        addConstreints()
    }
    
    @objc func addNote() {
        let note = NoteItem(title: titleField.text ?? "", text: textView.text ?? "", date: Date())
        service.create(note: note) { isAdd in
            if isAdd {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func addSubViews() {
        
        view.addSubview(titleField)
        view.addSubview(textView)
        view.addSubview(button)
    }
    
    func addConstreints() {
        
        NSLayoutConstraint.activate([
            
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 50),
            
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
