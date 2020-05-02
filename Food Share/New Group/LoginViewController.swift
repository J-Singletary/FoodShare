//
//  LoginViewController.swift
//  Food Share
//
//  Created by user170197 on 4/17/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    
    func setUpElements() {
        //hide the error label
        errorLabel.alpha = 0
        
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate text fields
        let error = self.validateFields()
        
        if error != nil {
            
            //There was an error
            showError(error!)
            
        }
        
        //Clean up data
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: pass) { (result, err) in
            if err != nil {
                
                //there was an error signing in
                self.showError(err!.localizedDescription)
                
            }
            else {
                let name = Auth.auth().currentUser?.displayName
                if name == nil {
                    let handle = Auth.auth().addStateDidChangeListener({ (Auth, user) in
                        let changeRequest = user?.createProfileChangeRequest()
                        changeRequest?.displayName = "FirstName"
                        changeRequest?.commitChanges(completion: { (err) in
                            print("Changed name")
                        })
                    })
                    
                }
                
                self.transitionToHome()
            }
        }
        
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboards.tabBarViewController)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
