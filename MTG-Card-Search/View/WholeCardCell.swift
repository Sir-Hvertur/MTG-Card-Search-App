//
//  WholeCardCell.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 06/03/2021.
//

import UIKit
import SwipeCellKit

class WholeCardCell: SwipeTableViewCell {

    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
