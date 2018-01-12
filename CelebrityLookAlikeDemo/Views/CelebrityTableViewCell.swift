//
//  CelebrityTableViewCell.swift
//  CelebrityLookAlikeDemo
//
//  Created by John Henning on 1/12/18.
//  Copyright © 2018 Knock. All rights reserved.
//

import UIKit

class CelebrityTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var celebImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
