//
//  Post.swift
//  Food Share
//
//  Created by user170197 on 5/1/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit

class Offer {
    
    //Properties
    
    var name: String
    
    var photo: UIImage
    
    var description: String
    
    var food: String
    
    
    //Initialize offer
    
    init(name: String, photo: UIImage?, description: String, food: String) {
        
        self.name = name
        
        self.photo = photo!
        
        self.description = description
        
        self.food = food
        
    }
    
    
}


