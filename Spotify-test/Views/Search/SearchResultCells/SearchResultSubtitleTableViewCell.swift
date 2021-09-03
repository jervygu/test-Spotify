//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        backgroundColor = .systemBackground
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(subTitlelabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height/1.2
        iconImageView.frame = CGRect(
            x: 20,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize)
//        iconImageView.layer.cornerRadius = imageSize/2
//        iconImageView.layer.masksToBounds = true
        
        let labelHeight = contentView.height/4
        label.frame = CGRect(
            x: iconImageView.right+15,
            y: contentView.height * 0.25,
            width: contentView.width-iconImageView.width-50,
            height: labelHeight)
//        label.backgroundColor = .darkGray
        
        subTitlelabel.frame = CGRect(
            x: iconImageView.right+15,
            y: contentView.height * 0.5,
            width: contentView.width-iconImageView.width-50,
            height: labelHeight)
//        subTitlelabel.backgroundColor = .brown
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTitlelabel.text = nil
        
    }
    
    func configure(withViewModel viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subTitlelabel.text = viewModel.subTitle
        
        iconImageView.sd_setImage(
            with: viewModel.imageURL,
            placeholderImage: UIImage(named: "playlistPlaceholder"),
            completed: nil)
    }
    
}
