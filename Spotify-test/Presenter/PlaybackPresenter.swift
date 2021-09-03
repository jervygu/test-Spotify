//
//  PlaybackPresenter.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subTitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.queuePlayer, !tracks.isEmpty {
//            let item = player.currentItem
//            let items = player.items()
//            guard let index = items.firstIndex(where: { $0 == item }) else {
//                return nil
//            }
            return tracks[index]
        }
        return nil
    }
    
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    
    func startPlayback(fromVC viewController: UIViewController, track: AudioTrack) {
        
        guard let trackkUrl = URL(string: track.preview_url ?? "") else {
            return
        }
        
        player = AVPlayer(url: trackkUrl)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        
        let vc = PlayerViewController()
        
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
        
    }
    
    func startPlayback(fromVC viewController: UIViewController, tracks: [AudioTrack]) {
        
        self.tracks = tracks
        self.track = nil
        
        self.queuePlayer = AVQueuePlayer(items: tracks.compactMap({
            guard let trackUrl = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: trackUrl)
        }))
        self.queuePlayer?.volume = 0.5
        self.queuePlayer?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPauseButton() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = queuePlayer {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapBackButton() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
            player?.play()
        } else if let firstItem = queuePlayer?.items().first {
            queuePlayer?.pause()
            queuePlayer?.removeAllItems()
            queuePlayer = AVQueuePlayer(items: [firstItem])
            queuePlayer?.play()
            queuePlayer?.volume = 0.5
            
        }
    }
    
    func didTapNextButton() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
        } else if let player = queuePlayer {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subTitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}



