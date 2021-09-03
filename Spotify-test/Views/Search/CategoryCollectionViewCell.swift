//
//  CategoryCollectionViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifer = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
        
        imageView.transform = CGAffineTransform(rotationAngle: 0.436332537394482)
        
        return imageView
    }()
    
    private let genrelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let colors: [UIColor] = [
        .brown,
        .systemGreen,
        .systemPink,
        .systemTeal,
        .systemPurple,
        .systemBlue,
        .systemRed,
        .systemIndigo,
        .systemOrange,
        .systemYellow
    ]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(genrelabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genrelabel.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        genrelabel.frame = CGRect(
            x: 10,
            y: 0,
            width: (contentView.width/1.6),
            height: contentView.height/2)
//        genrelabel.backgroundColor = .black
        
        let imageSize = contentView.width/2.8
        
        imageView.frame = CGRect(
            x: (contentView.width/1.40),
            y: contentView.height-imageSize,
            width: imageSize,
            height: imageSize)
//        imageView.backgroundColor = .red
        
    }
    
    func configure(withModel model: CategoryCollectionViewCellViewModel) {
        genrelabel.text = model.title
        imageView.sd_setImage(with: model.icons, completed: nil)
        
        
        contentView.backgroundColor = colors.randomElement()
        
    }
    
    
}

