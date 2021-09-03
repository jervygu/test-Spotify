//
//  PlayerViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPauseButton()
    func didTapBackButton()
    func didTapNextButton()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .systemBlue
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.random().cgColor, UIColor.systemBackground]
        return gradient
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(gradient)
        
        
        
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        
        configure()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // gradient
        
        view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        let imageSize = view.width/1.2
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top+(view.width-imageSize)/2,
            width: imageSize,
            height: imageSize)
        
        let controlsViewWidth = view.width/1.1
        controlsView.frame = CGRect(
            x: (view.width-controlsViewWidth)/2,
            y: view.width+30,
            width: controlsViewWidth,
            height: controlsViewWidth-20)
        
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configureLabels(
            withViewModel: PlayerControlsViewViewModel(
                title: dataSource?.songName,
                subTitle: dataSource?.subTitle))
    }
    
    private func  configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // actions
    }
    
    func refreshUI() {
        configure()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        // play / pause song
        delegate?.didTapPlayPauseButton()
    }
    
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView) {
        // previous song
        delegate?.didTapBackButton()
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
        // next song
        delegate?.didTapNextButton()
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        // volume
        delegate?.didSlideSlider(value)
    }
    
}
