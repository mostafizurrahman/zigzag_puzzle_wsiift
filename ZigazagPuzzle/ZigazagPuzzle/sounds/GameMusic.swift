//
//  GameMusic.swift
//  ZigazagPuzzle
//
//  Created by Mostafizur Rahman on 7/12/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit
import AVFoundation

class GameMusic: NSObject {

    var player: AVAudioPlayer?
    
    func play(Sound soundFile:String, fileType:String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: fileType) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint:
                (fileType == "mp3" ? AVFileType.mp3.rawValue : AVFileType.ac3.rawValue))
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
