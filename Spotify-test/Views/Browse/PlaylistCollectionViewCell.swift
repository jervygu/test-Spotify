//
//  PlaylistCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(optionButton)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height
        
        trackNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        
        playlistCoverImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        
        trackNameLabel.frame = CGRect(
            x: playlistCoverImageView.right+15,
            y: contentView.height/4,
            width: contentView.width-imageSize-60,
            height: (contentView.height/4))
//        trackNameLabel.backgroundColor = .systemTeal
        
        
        artistNameLabel.frame = CGRect(
            x: playlistCoverImageView.right+15,
            y: (contentView.height)/4+trackNameLabel.height,
            width: contentView.width-imageSize-60,
            height: (contentView.height/4))
//        artistNameLabel.backgroundColor = .systemIndigo
        
        optionButton.frame = CGRect(
            x: trackNameLabel.right+5,
            y: 0,
            width: contentView.width-trackNameLabel.width-imageSize-25,
            height: imageSize)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(withModel model: RecommendedTracksCellViewModel) {
        trackNameLabel.text = model.name
        artistNameLabel.text = model.artistName
        playlistCoverImageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }
    
}
