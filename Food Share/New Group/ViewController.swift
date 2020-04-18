//
//  ViewController.swift
//  Food Share
//
//  Created by Christian Lay-Geng on 4/12/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        
    }
    
    
}

