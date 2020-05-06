//
//  RequestCell.swift
//  
//
//  Created by user170197 on 5/6/20.
//

import UIKit

class RequestCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Request) {
        
        descriptionLabel.text = post.description
        
        typeLabel.text = post.food
        
        nameLabel.text = post.name
        
    }

}
