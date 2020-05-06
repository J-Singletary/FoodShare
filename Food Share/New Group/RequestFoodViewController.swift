//
//  RequestFoodViewController.swift
//  Food Share
//
//  Created by Christian Lay-Geng on 5/5/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class RequestFoodViewController: UIViewController {

    @IBOutlet weak var RequestFoodTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Verify any errors
        setUpElements()
    
    }
    
    func setUpElements() {
        //Hide the error label
        ErrorLabel.alpha = 0
    }
    
    //Check the fields and validate that they are correct. If everything is correct, this method returns 'nil', otherwise it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled
        if RequestFoodTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            DescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    // On button click push the data to Firebase
    @IBAction func PostButtonTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //There is something wrong with the fields, show error message
            showError(error!)
            
        }
        else {
            
            //Create cleaned data and push it to firebase
            let food = self.RequestFoodTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let description = self.DescriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //There was no error in the text fields, push the data to Firebase
            let db = Firestore.firestore()
            
            //get a reference to the user
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let user = Auth.auth().currentUser?.displayName
            
            db.collection("Post(Request)").addDocument(data: ["username": user as Any, "foodName": food, "description": description, "dateCreated": Timestamp.init()]) { (error) in
                if error != nil {
                    self.showError("Post could not be created")
                    print("Error creating post")
                }
            }
            
            self.transitionToHome()
            
        }
    }
    
    // Print error message and display it
    func showError(_ message: String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    // Return to homescreen after a post
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboards.tabBarViewController)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
