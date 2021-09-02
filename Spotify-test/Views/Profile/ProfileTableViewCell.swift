//
//  ProfileTableViewCell.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/1/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        valueLabel.sizeToFit()
        
        titleLabel.frame = CGRect(x: 16,
                                  y: 0,
                                  width: (contentView.width*0.33)-16,
                                  height: contentView.height)
        valueLabel.frame = CGRect(x: titleLabel.right,
                                  y: 0,
                                  width: (contentView.width*0.66)-16,
                                  height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with model: ProfileData) {
        titleLabel.text = model.title+":"
        valueLabel.text = model.value
    }
    
}
