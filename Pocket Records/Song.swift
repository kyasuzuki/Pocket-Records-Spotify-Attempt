//
//  Song.swift
//  Pocket Records
//
//  Created by Kya Suzuki on 7/19/17.
//  Copyright © 2017 Kya Suzuki. All rights reserved.
//

import UIKit

class Song {
    
    //MARK: Properties
    
    var songTitle: String
    var songArtist: String
    var albumImage: UIImage?
    var canvasImage: UIImage?
    
    //MARK: Initialization
    
    
    init?(songTitle: String, songArtist: String, albumImage: UIImage?, canvasImage: UIImage?) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if songTitle.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.albumImage = albumImage
        self.canvasImage = canvasImage
        
    }
    
}
