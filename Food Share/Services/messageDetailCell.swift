//
//  messageDetailCell.swift
//  Food Share
//
//  Created by user173563 on 5/2/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class messageDetailCell: UITableViewCell {
    
    @IBOutlet weak var recipientName: UILabel!
    
    @IBOutlet weak var charPreview: UILabel!
    
    var messageDetail: messageDetail!
    
    var userPostKey: FIRDatabaseReference!
    
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(messageDetail: messageDetail) {
        self.messageDetail = messageDetail
        
        let recipientData = FIRDatabase.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! Dictionary<String, AnyObject>.Element
            
            let username = data["username"]
            
            self.recipientName.text = username as? String
    }
}
