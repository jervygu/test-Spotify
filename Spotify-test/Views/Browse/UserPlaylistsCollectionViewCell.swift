//
//  UserPlaylistsCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class UserPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "UserPlaylistsCollectionViewCell"
    
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "launchLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = .red
        
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(creatorNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.width
//        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-10, height: contentView.height-10))
        
        playlistNameLabel.sizeToFit()
        creatorNameLabel.sizeToFit()
        
        
        playlistCoverImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        
        playlistNameLabel.frame = CGRect(
            x: 0,
            y: playlistCoverImageView.height+5,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.40)
//        playlistNameLabel.backgroundColor = .systemTeal
        
        
        creatorNameLabel.frame = CGRect(
            x: 0,
            y: playlistNameLabel.bottom+5,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.40)
//        creatorNameLabel.backgroundColor = .systemIndigo
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        numberOfTracksLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(withModel model: CurrentUserPlaylistsCellViewModel) {
        playlistNameLabel.text = model.name
        let songTxt = (model.numberOfTracks > 1) ? "songs" : "song"
        creatorNameLabel.text = "by \(model.creatorName) • \(model.numberOfTracks) \(songTxt)"
        numberOfTracksLabel.text = "\(model.numberOfTracks) \(songTxt)"
        playlistCoverImageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }

    
}
