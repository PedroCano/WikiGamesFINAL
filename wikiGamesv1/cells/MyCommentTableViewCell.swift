//
//  MyCommentTableViewCell.swift
//  wikiGamesv1
//
//  Created by DAW on 11/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class MyCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbMyDate: UILabel!
    @IBOutlet weak var lbMyComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
