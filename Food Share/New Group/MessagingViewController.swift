//
//  MessagingViewController.swift
//  Food Share
//
//  Created by user170197 on 5/1/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SwiftKeychainWrapper

class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var postCollectionRef: CollectionReference!
        
    var messageDetail = [MessageDetail]()
    
    var detail: MessageDetail!
    
    // currentUser was nil when using KeychainWarpper
//    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var currentUser = Auth.auth().currentUser?.uid

    
    var recipient: String!
    
    var messageID: String!
    
    
    
    @IBAction func onNewMsg(_ sender: Any) {
        performSegue(withIdentifier: "toSearchVC", sender: UIButton.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        postCollectionRef = Firestore.firestore().collection("Post(Offer)")
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.messageDetail.removeAll()
                
                for data in snapshot {
                    if let messageDict = data.value as? Dictionary<String,AnyObject> {
                        
                        let key = data.key
                        
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageDet = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? messageDetailCell {
            
            cell.configureCell(messageDetail: messageDet)
            
            return cell
        } else {
     
        return messageDetailCell()
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = messageDetail[indexPath.row].recipient
        
        messageID = messageDetail[indexPath.row].messageRef.key
        
            performSegue(withIdentifier: "toMessages", sender: Any?.self)
        }
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "toSearchVC" {
                let searchVC = segue.destination as! SearchVC
                print("GOING TO SEAERCH")
                searchVC.messageId = self.messageID
            }
//        if let destinationViewController = segue.destination as? MessageVC {
//            destinationViewController.recipient = recipient
//
//            destinationViewController.messageId = self.messageID
//        }
    }
}
}
