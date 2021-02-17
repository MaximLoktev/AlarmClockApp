//
//  PlayingService.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 13.02.2021.
//

import AVFoundation

protocol PlayingService {
    func start(with url: URL, completion: @escaping (Result<Void, Error>) -> Void)
    func stop()
}

final class PlayingServiceImpl: PlayingService {
    
    // MARK: - Properties
    
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Actions
    
    func start(with url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        tryToPlay(with: url, completion: completion)
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    // MARK: - Private actions
    
    private func tryToPlay(with url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

