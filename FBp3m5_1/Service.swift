//
//  Service.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 22.03.2024.
//

import Firebase
import Foundation
import FirebaseAuth
import FirebaseStorage
import CoreLocation

class Service {
    
    func create(note: NoteItem, completion: @escaping (Bool) -> ()) {
        let noteData: [String: Any] = [
            "title": note.title,
            "note": note.text,
            "date": note.date,
            "isActive": false
        ]
        
        Firestore.firestore()
            .collection("notes")
            .document(note.id)
            .setData(noteData) { error in
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                    print(error?.localizedDescription ?? "")
                }
            }
    }
    
    func getAllNotes(completion: @escaping ([NoteItem]) -> ()) {
        Firestore.firestore()
            .collection("notes")
            .order(by: "date", descending: true)
            .limit(to: 5)
        //            .start(at: <#T##[Any]#>)
            .addSnapshotListener { snapshot, error in
                guard error == nil else {return}
                guard let documents = snapshot?.documents else {return}
                var allNotes = [NoteItem]()
                documents.forEach { document in
                    var date: Date {
                        if let timeStamp = document["date"] as? Timestamp {
                            return timeStamp.dateValue()
                        }
                        return Date()
                    }
                    
                    
                    let oneNote = NoteItem(id: document.documentID,
                                           title: document["title"] as? String ?? "",
                                           text: document["note"] as? String ?? "",
                                           date: date)
                    allNotes.append(oneNote)
                }
                completion(allNotes)
            }
    }
    
    func getDeleteNote(noteId: String) {
        Firestore.firestore()
            .collection("notes")
            .document(noteId)
            .delete()
    }
    
    func checkAuth() -> Bool {
        if let _ = Auth.auth().currentUser?.uid{
            return true
        }
        return false
    }
    
    func signIn(for user: UserLoginData, completion: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    print("invalidEmail")
                case AuthErrorCode.wrongPassword.rawValue:
                    print("wrongPassword")
                case AuthErrorCode.appNotVerified.rawValue:
                    print("appNotVerified")
                default:
                    print("error")
                }
                completion(false)
                return
            }
            guard result != nil else {
                completion(false)
                return
            }
            if let user = result?.user.isEmailVerified, user {
                completion(true)
            } else {
                print("isEmailVerified")
                self.signOut()
                completion(false)
            }
        }
    }
    
    func regNewUser(for user: UserLoginData, with userInfo: UserInfo, completion: @escaping (Bool) -> ()) {
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { result, error in
            if let error = error as? NSError {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    print("emailAlreadyInUse")
                default:
                    print("error")
                }
                completion(false)
                return
            }
            guard let uid = result?.user.uid else {
                completion(false)
                return
            }
            result?.user.sendEmailVerification()
            let userData: [String: Any] = [
                "name": userInfo.name,
                "surname": userInfo.surname,
                "date": userInfo.date
            ]
            Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(userData)
            self.signOut()
            completion(true)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setAvatar(image: Data) {
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        let path = Firestore.firestore().collection("users")
            .document(uid)
        let storage = Storage.storage().reference()
            .child("files/")
            .child(uid)
            .child("avatar")
        saveOnePhoto(image: image, uid: uid, storage: storage) { result in
            switch result {
                
            case .success(let url):
                path.updateData(["photoURL" : url.absoluteString])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveOnePhoto(image imageData: Data, uid: String, storage: StorageReference, completion: @escaping (Result<URL, Error>) -> ()) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        DispatchQueue.main.async {
            storage.putData(imageData, metadata: metaData) { data, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                storage.downloadURL { url, error in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
    func getUserData(completion: @escaping (String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard error == nil else {return}
            guard let document = snapshot?.data() else {return}
            if let photoURL = document["photoURL"] as? String {
                completion(photoURL)
            }
        }
    }
    
    func saveLocation(location: CLLocation?) {
        guard let location = location else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let saveLocation: [String: Any] = [
            "location": [
                "lat": location.coordinate.latitude,
                "lon": location.coordinate.longitude
            ]
        ]
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData(["userLocation" : saveLocation])
    }
}

struct NoteItem: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var text: String
    var date: Date
}

struct UserLoginData {
    var email: String
    var password: String
}

struct UserInfo {
    var name: String
    var surname: String
    var date: Date
}
