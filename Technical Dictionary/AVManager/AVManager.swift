//
//  AVManager.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-07.
//

import Foundation
import AVKit

enum AVErrors:Error{
    case loadVideoError, loadImageError
}

class AVManager {
    static let shared = AVManager();private init(){}
    func loadVideo(_ data:Data, id:UUID, completion:@escaping(Result<URL,Error>)->()){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let videoFolder = documentDirectory.appendingPathComponent("Video", isDirectory: true)
        try? FileManager.default.createDirectory(at: videoFolder, withIntermediateDirectories: true)
        
        let videoURL = videoFolder.appendingPathComponent("\(id).mp4")
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try data.write(to: videoURL)
                completion(.success(videoURL))
            } catch {
                completion(.failure(AVErrors.loadVideoError))
            }
        }
    }
    func showPlayer(_ player:AVPlayer){
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
    func loadImage(_ data:Data, completion:@escaping(Result<UIImage,Error>)->()){
        guard let image = UIImage(data: data) else { completion(.failure(AVErrors.loadImageError))
            return}
        completion(.success(image))
    }
}
