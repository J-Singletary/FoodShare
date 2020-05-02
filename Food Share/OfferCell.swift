//
//  OfferCell.swift
//  Food Share
//
//  Created by user170197 on 5/1/20.
//  Copyright © 2020 Christian Lay-Geng. All rights reserved.
//

import UIKit

class OfferCell: UITableViewCell {

    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post) {
        foodImage.image = post.photo
        
        descriptionLabel.text = post.description
        
        typeLabel.text = post.food
        
        nameLabel.text = post.name
    }

}
