//
//  NewReleaseCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import UIKit
import SDWebImage


class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "launchLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
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
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height
//        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-10, height: contentView.height-10))
        
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        albumNameLabel.sizeToFit()
        
        
        albumCoverImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: imageSize,
            height: imageSize)
        
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 5,
            width: contentView.width-imageSize-15,
            height: (contentView.height*0.66)-5)
//        albumNameLabel.backgroundColor = .systemTeal
        
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumNameLabel.height,
            width: contentView.width-imageSize-15,
            height: (contentView.height*0.33))
//        artistNameLabel.backgroundColor = .systemIndigo
        

        numberOfTracksLabel.frame = CGRect(
            x: 5,
            y: contentView.height-(imageSize/3),
            width: imageSize-5,
            height: imageSize/3)
//        numberOfTracksLabel.backgroundColor = .systemGreen
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(withModel model: NewReleasesCellViewModel) {
        albumNameLabel.text = model.name
        artistNameLabel.text = model.artistName
        let songTxt = (model.numberOfTracks > 1) ? "songs" : "song"
        numberOfTracksLabel.text = "\(model.numberOfTracks) \(songTxt)"
        albumCoverImageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }
    
}
