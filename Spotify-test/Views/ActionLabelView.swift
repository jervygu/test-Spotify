//
//  ActionLabelView.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        clipsToBounds = true
        
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(
            x: 0,
            y: height-55,
            width: width,
            height: 40)
//        button.backgroundColor = .red
        
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height-60)
//        label.backgroundColor = .systemPink
        
    }
    
    func configure(withViewModel viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }

}
