//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import UIKit

class RecommendedTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "launchLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.width
//        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-10, height: contentView.height-10))
        
        trackNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        
        
        playlistCoverImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        
        trackNameLabel.frame = CGRect(
            x: 0,
            y: playlistCoverImageView.height,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.66)
//        trackNameLabel.backgroundColor = .systemTeal
        
        
        artistNameLabel.frame = CGRect(
            x: 0,
            y: trackNameLabel.bottom,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.33)
//        artistNameLabel.backgroundColor = .systemIndigo
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(withModel model: RecommendedTrackCellViewModel) {
        trackNameLabel.text = model.name
        artistNameLabel.text = "by \(model.artistName)"
        playlistCoverImageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }
    
}
