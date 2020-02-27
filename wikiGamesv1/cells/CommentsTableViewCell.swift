//
//  CommentsTableViewCell.swift
//  wikiGamesv1
//
//  Created by dam on 10/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
