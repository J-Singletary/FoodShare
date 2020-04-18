//
//  SignUpViewController.swift
//  Food Share
//
//  Created by user170197 on 4/17/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //Hide the error label
        errorLabel.alpha = 0
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Check that a password meets the criteria for being valid
    func isPasswordValid(_ password : String) -> Bool {
        let passwordvalid = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?@]{8,}")
        return passwordvalid.evaluate(with: password)
    }
    
    
    //Check the fields and validate that they are correct. If everything is correct, this method returns 'nil', otherwise it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is 8 characters long, contains a special character and a number"
        }
        
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //There is something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            //create the user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
                
                //check for errors
                if err != nil {
                    
                    //There was an error
                    self.showError("Error creating user")
                }
                else {
                    
                    //Create cleaned versions of the data
                    let firstName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let lastName = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let pass = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    //There was no error creating the user. Now store the first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["first_Name": firstName, "last_Name": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("User data could not be saved")
                        }
                    }
                    
                    //transition to home screen
                    self.transitionToHome()
                    
                }
            }
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboards.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    

}
