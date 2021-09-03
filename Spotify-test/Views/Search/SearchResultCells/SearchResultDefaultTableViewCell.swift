//
//  SearchResultDefaultTableViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class SearchResultDefaultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        contentView.addSubview(label)
        contentView.addSubview(subLabel)
        contentView.addSubview(iconImageView)
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
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        
//        let labelHeight = contentView.height
//        label.frame = CGRect(
//            x: iconImageView.right+15,
//            y: 0,
//            width: contentView.width-iconImageView.width-50,
//            height: labelHeight)
//        label.backgroundColor = .systemOrange
        
        label.sizeToFit()
        let labelHeight = contentView.height/4
        label.frame = CGRect(
            x: iconImageView.right+15,
            y: contentView.height * 0.25,
            width: contentView.width-iconImageView.width-50,
            height: labelHeight)
//        label.backgroundColor = .darkGray
        
        subLabel.sizeToFit()
        subLabel.frame = CGRect(
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
        subLabel.text = nil
        
    }
    
    func configure(withViewModel viewModel: SearchResultDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        subLabel.text = viewModel.type
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)

    }
    
}
