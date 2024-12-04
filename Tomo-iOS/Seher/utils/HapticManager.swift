import SwiftUI
import AVFoundation

class HapticManager {
    static let shared = HapticManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func playSound(named filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play sound: \(error)")
        }
    }
} 
