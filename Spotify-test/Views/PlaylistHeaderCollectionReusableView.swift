//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header :PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "launchLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 20,
                                weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.random().cgColor, UIColor.systemBackground]
        return gradient
    }()
    
    // MARK:- Init
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .systemBackground
        
        addSubview(bgView)
        layer.addSublayer(gradient)
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
//        addSubview(numberOfTracksLabel)
        addSubview(playlistCoverImageView)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAllBtn), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayAllBtn(){
        // play all
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*1.3)
        gradient.frame = bgView.bounds
        bgView.layer.insertSublayer(gradient, at: 0)
//        bgView.backgroundColor = .red
        
        
        let imageSize: CGFloat = width/1.8
        playlistCoverImageView.frame = CGRect(
            x: (width-imageSize)/2,
            y: 20,
            width: imageSize,
            height: imageSize)
        
        nameLabel.frame = CGRect(
            x: 10,
            y: 25+imageSize,
            width: width-playAllButton.width-100,
            height: 30)
//        nameLabel.backgroundColor = .systemPink
        
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: 25+imageSize+nameLabel.height,
            width: width-playAllButton.width-100,
            height: 15)
//        descriptionLabel.backgroundColor = .systemTeal
        
        ownerLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: 25+imageSize+nameLabel.height+descriptionLabel.height,
            width: width-20,
            height: 15)
//        ownerLabel.backgroundColor = .systemPink
        
//        numberOfTracksLabel.frame = CGRect(
//            x: ownerLabel.right,
//            y: 25+imageSize+nameLabel.height+descriptionLabel.height,
//            width: width/4,
//            height: 15)
//        numberOfTracksLabel.backgroundColor = .systemBlue
        
        playAllButton.frame = CGRect(
            x: width-70,
            y: imageSize+nameLabel.height,
            width: 50,
            height: 50)
        
        
    }
    
    func configure(withModel model: PlaylistHeaderViewViewModel){
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        let songTxt = (model.total! > 1) ? "songs" : "song"
        
        guard let total = model.total, let owner = model.ownerName else{
            return
        }
        ownerLabel.text = "\(owner) • \(total) \(songTxt)"
        numberOfTracksLabel.text = ""
        playlistCoverImageView.sd_setImage(
            with: model.artworkURL,
            placeholderImage: UIImage(named: "playlistPlaceholder"),
            completed: nil)
    }
    
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
