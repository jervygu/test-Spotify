//
//  LibraryToggleView.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlists
        case albums
    }
    
    var state: State = .playlists
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.setTitle("Albums", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .darkGray
        
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlaylists() {
        state = .playlists
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicatorConfig()
        }
        
        delegate?.LibraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        state = .albums
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicatorConfig()
        }
        
        delegate?.LibraryToggleViewDidTapAlbums(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistsButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 90,
            height: 40)
//        playlistsButton.backgroundColor = .systemRed
        
        albumsButton.frame = CGRect(
            x: playlistsButton.right,
            y: 0,
            width: 90,
            height: 40)
//        albumsButton.backgroundColor = .systemRed
        
        layoutIndicatorConfig()
        
        
    }
    
    private func layoutIndicatorConfig() {
        switch state {
        case .playlists:
            indicatorView.frame = CGRect(
                x: 15,
                y: playlistsButton.height,
                width: playlistsButton.width-30,
                height: 2)
            
            playlistsButton.setTitleColor(.label, for: .normal)
            albumsButton.setTitleColor(.secondaryLabel, for: .normal)
        case .albums:
            indicatorView.frame = CGRect(
                x: 107,
                y: albumsButton.height,
                width: albumsButton.width-34,
                height: 2)
            
            albumsButton.setTitleColor(.label, for: .normal)
            playlistsButton.setTitleColor(.secondaryLabel, for: .normal)
        }
    }
    
    func update(forState state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicatorConfig()
        }
    }
    
}
