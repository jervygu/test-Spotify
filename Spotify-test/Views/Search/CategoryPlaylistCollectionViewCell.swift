//
//  CategoryPlaylistCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit
import SDWebImage

class CategoryPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryPlaylistCollectionViewCell"
    
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "launchLogo")
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
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
//        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
//        contentView.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.width
//        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-10, height: contentView.height-10))
        
        playlistNameLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        
        playlistCoverImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        
        playlistNameLabel.frame = CGRect(
            x: 0,
            y: playlistCoverImageView.bottom,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.50)
//        playlistNameLabel.backgroundColor = .systemTeal
        
        
        descriptionLabel.frame = CGRect(
            x: 0,
            y: playlistNameLabel.bottom,
            width: contentView.width,
            height: (contentView.height-imageSize)*0.50)
//        descriptionLabel.backgroundColor = .systemIndigo
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        descriptionLabel.text = nil
        numberOfTracksLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(withModel model: CategoryPlaylistCellViewModel) {
        playlistNameLabel.text = model.name
        let songTxt = ((model.numberOfTracks ?? 0) > 1) ? "songs" : "song"
//        creatorNameLabel.text = "by \(model.creatorName) • \(model.numberOfTracks) \(songTxt)"
        descriptionLabel.text = model.description
        
        numberOfTracksLabel.text = "\(String(describing: model.numberOfTracks)) \(songTxt)"
        playlistCoverImageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }

}
