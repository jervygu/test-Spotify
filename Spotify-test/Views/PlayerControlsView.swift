//
//  PlayerControlsView.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subTitle: String?
}

final class PlayerControlsView: UIView {
    
    private var isPlaying = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .secondaryLabel
         
        return slider
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.end.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .ultraLight))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.end.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .ultraLight))
        button.setImage(image, for: .normal)
        return button
    }()
     
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 60,
                weight: .ultraLight))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .systemGray
        clipsToBounds = true
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.text = "Title"
        subTitleLabel.text = "Artist"
        
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(nextButton)
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc private func didTapBackButton() {
        delegate?.playerControlsViewDidTapBackButton(self)
    }
    @objc private func didTapNextButton() {
        delegate?.playerControlsViewDidTapNextButton(self)
    }
    @objc private func didTapPlayPauseButton() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        

        // toggle play pause
        let pause = UIImage(
            systemName: "pause.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 60,
                weight: .ultraLight))
        
        let play = UIImage(
            systemName: "play.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 60,
                weight: .ultraLight))
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: width-20,
            height: width/10)
//        titleLabel.backgroundColor = .systemTeal
        
        subTitleLabel.frame = CGRect(
            x: 10,
            y: titleLabel.height,
            width: width-20,
            height: width/13)
//        subTitleLabel.backgroundColor = .systemPink
        
        volumeSlider.frame = CGRect(
            x: 5,
            y: 10+titleLabel.height+10+subTitleLabel.height,
            width: width-10,
            height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(
            x: (width-buttonSize)/2,
            y: (width-buttonSize)/2,
            width: buttonSize,
            height: buttonSize)
//        playPauseButton.backgroundColor = .systemPink
        
        backButton.frame = CGRect(
            x: playPauseButton.left-40-buttonSize,
            y: (width-buttonSize)/2,
            width: buttonSize,
            height: buttonSize)
//        backButton.backgroundColor = .systemPink
        
        nextButton.frame = CGRect(
            x: playPauseButton.right+40,
            y: (width-buttonSize)/2,
            width: buttonSize,
            height: buttonSize)
//        nextButton.backgroundColor = .systemPink
    }
    
    
    func configureLabels(withViewModel viewModel: PlayerControlsViewViewModel) {
        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
    }
}
