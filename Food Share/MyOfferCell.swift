//
//  MyOfferCell.swift
//  Food Share
//
//  Created by user170197 on 5/9/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit

class MyOfferCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(post: Offer) {
        foodImage.image = post.photo
        
        descriptionLabel.text = post.description
        
        foodLabel.text = post.food
        
        nameLabel.text = post.name
    }
    
}
