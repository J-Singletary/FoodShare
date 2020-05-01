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
import Photos

class OfferFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var OfferFoodTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    //Variable to access photo library
    var imagePickerController = UIImagePickerController()
    var photoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Verify any errors
        setUpElements()
        
        // Set up ImageController to ask permission
        imagePickerController.delegate = self
        checkPermissions()
    }
    
    func setUpElements() {
        //Hide the error label
        ErrorLabel.alpha = 0
    }
    
    //Check the fields and validate that they are correct. If everything is correct, this method returns 'nil', otherwise it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled
        if OfferFoodTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            DescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || photoId.isEmpty
        {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    // Access photo library and add photo to firebase
    @IBAction func ImageButtonTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary //This can be switched to .camera to access actual phone camera
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    // Check if image permission is true
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    // Ask permission for photo library
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("We have permission for photos")
        } else {
            print("We don't have permission for photos")
        }
    }
    
    // Display the preview and call upload
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            uploadToCloud(fileURL: url)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    // Upload to Firebase Storage
    func uploadToCloud(fileURL : URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let localFile = fileURL
        
        // Set the name to a random digit string
        photoId = UUID.init().uuidString
        photoId = "\(photoId).jpg"
        let photoRef = storageRef.child(photoId)
        
        // Put the metadata and the photo to Storage
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil) { (metadata, err) in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Photo Uploaded!")
        }
        
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
            let food = self.OfferFoodTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let description = self.DescriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //There was no error in the text fields, push the data to Firebase
            let db = Firestore.firestore()
            
            //get a reference to the user
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let userID = Auth.auth().currentUser?.uid
            
            db.collection("posts").addDocument(data: ["user": userID as Any, "foodName": food, "description": description, "photoId": photoId, "dateCreated": Timestamp.init()]) { (error) in
                if error != nil {
                    self.showError("Post could not be created")
                }
            }
            
            self.transitionToHome()
            
        }
    }
    
    /*
     CODE FOR RETREIVING IMAGE BY PHOTOID INTO IMAGEVIEW FOR JARED:
     
     let photoRef = Storage.storage().reference().child(photoId)
     photoRef.getData(maxSize: 1*1024*1024*100) { (imageData, error) in
         let img = UIImage(data: imageData!)
         self.ImageView.image = img
     }
     
     */
    
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
