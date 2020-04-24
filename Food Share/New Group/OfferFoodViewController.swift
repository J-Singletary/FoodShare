//
//  OfferFoodViewController.swift
//  Food Share
//
//  Created by Christian Lay-Geng on 4/23/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class OfferFoodViewController: UIViewController {

    @IBOutlet weak var OfferFoodTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //Hide the error label
        ErrorLabel.alpha = 0
    }
    
    //Check the fields and validate that they are correct. If everything is correct, this method returns 'nil', otherwise it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled
        if OfferFoodTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
        }
    }
    
    func showError(_ message: String) {
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
}
