import SwiftUI
import AVFoundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("hapticEnabled") var hapticEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("musicVolume") var musicVolume: Double = 0.5
    @AppStorage("soundVolume") var soundVolume: Double = 0.7
    @AppStorage("difficulty") var difficulty: Int = 1 // 0=easy, 1=medium, 2=hard
    
    @Published var musicPlayer: AVAudioPlayer?
    
    private init() {
        setupMusic()
    }
    
    private func setupMusic() {
        // Setup background music player
        // In production, load actual music file
    }
    
    func playSound(_ sound: SoundManager.Sound) {
        guard soundEnabled else { return }
        SoundManager.shared.play(sound)
    }
    
    func triggerHaptic(_ type: SoundManager.HapticType = .light) {
        guard hapticEnabled else { return }
        SoundManager.shared.haptic(type)
    }
    
    func playMusic() {
        guard musicEnabled, musicPlayer == nil else { return }
        // In production: musicPlayer?.play()
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    var difficultyName: String {
        switch difficulty {
        case 0: return "Fácil"
        case 1: return "Medio"
        case 2: return "Difícil"
        default: return "Medio"
        }
    }
}
