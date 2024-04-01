//
//  ViewController.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 21.03.2024.
//

import UIKit
import Firebase
import SDWebImage

class ViewController: UIViewController {
    
    private let service = Service()
    private var notes = [NoteItem]()
    var tableData: [String] = ["1", "2", "3", "4", "5", "6"]
    
    lazy var indicator: UIRefreshControl = {
        $0.addTarget(self, action: #selector(reloadTable), for: .allEvents)
        return $0
    }(UIRefreshControl())
    
    lazy var table: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.addSubview(indicator)
        return $0
    }(UITableView(frame: .zero, style: .insetGrouped))
    
    lazy var avatarView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAvatar)))
        return $0
    }(UIImageView())
    
    lazy var button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Save", for: .normal)
        $0.backgroundColor = .green
        $0.addTarget(self, action: #selector(setData), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(showNextVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarView)
        view.backgroundColor = .white
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(table)
        view.addSubview(button)
        addConstreints()
        getAllNews()
        service.getUserData { photoURL in
            self.avatarView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "USA"))
        }
    }
    
    private func getAllNews() {
        service.getAllNotes { notes in
            self.notes = notes
            self.table.reloadData()
        }
    }
    
    @objc func selectAvatar() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func reloadTable() {
        getAllNews()
        indicator.endRefreshing()
    }
    
    @objc func showNextVC() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setData() {
        let data: [String: Any] = [
            "title": "Amina",
            "note": "amina",
            "date": Date(),
            "isActive": false
        ]
        
        Firestore.firestore()
            .collection("notes")
            .document(UUID().uuidString)
            .setData(data)
    }
    
    func addConstreints() {
        
        NSLayoutConstraint.activate([
            
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let docId = notes[indexPath.row].id
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            service.getDeleteNote(noteId: docId)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.avatarView.image = image
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                service.setAvatar(image: imageData)
            }
        }
        picker.dismiss(animated: true)
    }
}
