//
//  MessageDetail.swift
//  Food Share
//
//  Created by user173563 on 5/2/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageDetail {
    private var _recipient: String!
    
    private var _messageKey: String!
    
    var messageRef: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String {
        return _recipient
    }
    
    var messageKey: String {
        return _messageKey
    }
    
    var messageReff: DatabaseReference {
        return messageRef
    }
    
    init(recipient: String) {
        
        _recipient = recipient
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            _recipient = recipient
        }
        
        messageRef = Database.database().reference().child("recipient").child(_messageKey)
        
    }
}
