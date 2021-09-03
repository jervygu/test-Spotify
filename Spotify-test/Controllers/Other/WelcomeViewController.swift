//
//  WelcomeViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_white"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
     private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Millions of songs.\nFree on Spotify."
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "Spotify"
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(logoImageView)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        
        signInButton.frame = CGRect(
            x: 30,
            y: view.height-50-view.safeAreaInsets.bottom-30,
            width: view.width-60,
            height: 50)
        
        logoImageView.frame = CGRect(
            x: (view.width-60)/2,
            y: (view.height-60)/3,
            width: 60,
            height: 60)
        
        label.frame = CGRect(
            x: 30,
            y: (view.height/2)+20,
            width: view.width-60,
            height: 150)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or show error
        guard success else {
            let alert = UIAlertController(title: "Opps", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true, completion: nil)
        
    }
    

}
