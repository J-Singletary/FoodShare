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

class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var postCollectionRef: CollectionReference!
    
    var messageDetail = [MessageDetail]()
    
    var detail: MessageDetail!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String!
    
    var messageID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        postCollectionRef = Firestore.firestore().collection("Post(Offer)")
        
        FIRDatabase.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageDet = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? messageDetailCell {
            
            cell.configureCell(messageDetail: messageDet)
            
            return cell
        } else {
     
        return messageDetailCell()
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = messageDetail[indexPath.row].recipient
        
        messageId = messageDetail[indexPath.row].messageRef.key
        
        performSegue(withIdentifier: "toMessages", sender: Any?)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MessageVC {
            destinationViewController.recipient = recipient
            
            destinationViewController.messageID = messageId
        }
    }
}
}
