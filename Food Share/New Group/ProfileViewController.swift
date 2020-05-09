//
//  ProfileViewController.swift
//  Food Share
//
//  Created by user170197 on 4/22/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    
    private var userCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionRef = Firestore.firestore().collection("users")
        setupElements()

    }
    
    func setupElements() {
        let uid = Auth.auth().currentUser?.uid
        userCollectionRef.whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
            if err != nil {
                print("Error fetching user document")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    
                    let first = data["first_Name"] as? String ?? "Anonymous"
                    let last = data["last_Name"] as? String ?? "Anonymous"
                    let college = data["college"] as? String ?? "No College Found"
                    
                    let currentName = self.nameLabel.text
                    let fullName = "\(currentName ?? "Name: ") \(first) \(last)"
                    self.nameLabel.text = fullName
                    
                    let fullCollege = "College: \(college)"
                    self.collegeLabel.text = fullCollege
                    
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
        
        transitionToLogin()
    }
    
    func transitionToLogin() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboards.loginController)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
