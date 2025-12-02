//
//  SoundManager.swift
//  Commons
//
//  Created by Arthur Porto on 28/11/25.
//

import AVFoundation

@MainActor
public final class SoundManager: Sendable {
    public static let shared = SoundManager()
    
    private var player: AVAudioPlayer?

    public func play(_ name: String, ext: String = "wav", bundle: Bundle) {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            print("❌ Sound file not found:", name)
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error playing sound:", error)
        }
    }
}
