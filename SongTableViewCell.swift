//
//  SongTableViewCell.swift
//  Pocket Records
//
//  Created by Kya Suzuki on 7/18/17.
//  Copyright © 2017 Kya Suzuki. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var songTitleLabel: UILabel!
    
    @IBOutlet weak var songArtistLabel: UILabel!
    
    @IBOutlet weak var albumImageView: UIImageView!
    

    @IBOutlet weak var canvasImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }

}
