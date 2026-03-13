import AVFoundation
import Foundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    // Sound effect names
    enum Sound: String {
        case cardDeal = "card_deal"
        case cardPlay = "card_play"
        case trickWin = "trick_win"
        case gameWin = "game_win"
        case gameLose = "game_lose"
        case buttonTap = "button_tap"
    }
    
    private init() {
        // Preload sounds if available
        preloadSounds()
    }
    
    private func preloadSounds() {
        // In a real app, you'd load actual sound files
        // For now, we'll use system sounds as fallback
    }
    
    func play(_ sound: Sound) {
        // Using system sounds as placeholder
        // In production, replace with actual audio files
        switch sound {
        case .cardDeal:
            playSystemSound(1104) // Light
        case .cardPlay:
            playSystemSound(1104)
        case .trickWin:
            playSystemSound(1025) // Positive
        case .gameWin:
            playSystemSound(1025)
        case .gameLose:
            playSystemSound(1053) // Negative
        case .buttonTap:
            playSystemSound(1104)
        }
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    // Play haptic feedback
    func haptic(_ type: HapticType = .light) {
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    enum HapticType {
        case light, medium, heavy, success, error
    }
}

// Import for UIKit haptic feedback
import UIKit
