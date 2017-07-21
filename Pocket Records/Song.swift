//
//  Song.swift
//  Pocket Records
//
//  Created by Kya Suzuki on 7/19/17.
//  Copyright © 2017 Kya Suzuki. All rights reserved.
//

import UIKit
import os.log

class Song: NSObject, NSCoding {
    
    //MARK: Properties
    
    var songTitle: String
    var songArtist: String
    var albumImage: UIImage?
    var canvasImage: UIImage?
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("songs")
    
    // MARK: Types
    
    struct PropertyKey {
        static let songTitle = "songTitle"
        static let songArtist = "songArtist"
        static let albumImage = "albumImage"
        static let canvasImage = "canvasImage"
            }
    
    //MARK: Initialization
    
    
    init?(songTitle: String, songArtist: String, albumImage: UIImage?, canvasImage: UIImage?)
    {
        
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
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(songTitle, forKey: PropertyKey.songTitle)
        aCoder.encode(songArtist, forKey: PropertyKey.songArtist)
        aCoder.encode(albumImage, forKey: PropertyKey.albumImage)
        aCoder.encode(canvasImage, forKey: PropertyKey.canvasImage)
      
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let songTitle = aDecoder.decodeObject(forKey: PropertyKey.songTitle) as? String else {
            os_log("Unable to decode the name for a Song object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let songArtist = aDecoder.decodeObject(forKey: PropertyKey.songArtist) as? String else {
            os_log("Unable to decode the name for a Song object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because albumImage and canvasImage are optional properties of Song, just use the conditional cast.
        let albumImage = aDecoder.decodeObject(forKey: PropertyKey.albumImage) as? UIImage
        let canvasImage = aDecoder.decodeObject(forKey: PropertyKey.canvasImage) as? UIImage
        
        
        
        // Must call designated initializer.
        self.init(songTitle: songTitle, songArtist: songArtist, albumImage: albumImage, canvasImage: canvasImage)
    }
    
}
