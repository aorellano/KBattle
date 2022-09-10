//
//  AudioManager.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/9/22.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    var player: AVPlayer?
    
    func startPlayer(with song: String) {
        guard let url = URL(string: song) else { return }
        print(url)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }catch {
            print("The audio couldnt play")
        }
        
        player = AVPlayer(playerItem: AVPlayerItem(url: url))

        //player?.playImmediately(atRate: 1.0)
     
    }
    

}
