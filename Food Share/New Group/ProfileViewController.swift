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

    override func viewDidLoad() {
        super.viewDidLoad()

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
