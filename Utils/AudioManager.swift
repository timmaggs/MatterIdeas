//
//  AudioManager.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import AVFoundation

class AudioManager {
    
    static var audioPlayer: AVAudioPlayer?
    static var backgroundPlayer: AVAudioPlayer?
    static var checkboxPlayer: AVAudioPlayer?
    
    static func playSound(soundfile: String) {
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(soundfile)")
            }
        }
    }
    
    static func playBackgroundSound(soundfile: String) {
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil) {
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.setVolume(0.1, fadeDuration: 0)
                backgroundPlayer?.prepareToPlay()
                backgroundPlayer?.play()
            } catch {
                print("Error playing audio: \(soundfile)")
            }
        }
    }
    
    static func fadeInSound() {
        audioPlayer?.setVolume(1, fadeDuration: 0.3)
        backgroundPlayer?.setVolume(0.1, fadeDuration: 0.3)

    }
    
    static func fadeOutSound() {
        audioPlayer?.setVolume(0, fadeDuration: 0.3)
        backgroundPlayer?.setVolume(0, fadeDuration: 0.3)
    }
    
    static func playCheckboxSound(soundfile: String) {
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil) {
            do {
                checkboxPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                checkboxPlayer?.prepareToPlay()
                checkboxPlayer?.play()
            } catch {
                print("Error playing audio: \(soundfile)")
            }
        }
    }
}
