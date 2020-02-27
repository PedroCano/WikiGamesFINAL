//
//  ExerciseTableViewCell.swift
//  DeintTutorial3B
//
//  Created by DAW on 23/01/2020.
//  Copyright © 2020 DAW. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var labelAutor: UILabel!
    
    @IBOutlet weak var btV1: UIButton!
    @IBOutlet weak var btV2: UIButton!
    @IBOutlet weak var btV3: UIButton!
    @IBOutlet weak var btV4: UIButton!
    @IBOutlet weak var btV5: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageCell.alpha = 0.55
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
