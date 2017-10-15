//
//  GSAudio.swift
//  BringersOfWar
//
//  Copied and editted from https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time
//

import Foundation
import AVFoundation
class GSAudio: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = GSAudio()
    
    private override init() {}
    
    var players = [URL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    func playSound (soundFileName: String, volume: Float) {
        
        let path = Bundle.main.path(forResource: soundFileName, ofType:nil)!
        let soundFileNameURL = URL(fileURLWithPath: path)
        
        if let player = players[soundFileNameURL] { //player for sound has been found
            
            if player.isPlaying == false { //player is not in use, so use that one
                player.prepareToPlay()
                player.volume = volume
                player.play()
                player.volume = volume
                
            } else { // player is in use, create a new, duplicate, player and use that instead
                
                let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundFileNameURL)
                //use 'try!' because we know the URL worked before.
                
                duplicatePlayer.delegate = self
                //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing
                
                duplicatePlayers.append(duplicatePlayer)
                //add duplicate to array so it doesn't get removed from memory before finishing
                
                duplicatePlayer.prepareToPlay()
                duplicatePlayer.volume = volume
                duplicatePlayer.play()
                duplicatePlayer.volume = volume
            }
        } else { //player has not been found, create a new player with the URL if possible
            do{
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.volume = volume
                player.play()
                player.volume = volume
            } catch {
                print("Could not play sound file!")
            }
        }
    }
    func stopSounds() {
        for key in players.keys {
            players[key]?.pause()
            players[key] = nil
        }
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        duplicatePlayers.remove(at:duplicatePlayers.index(of:player)!)
        //Remove the duplicate player once it is done
    }
    
}
