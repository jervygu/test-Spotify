//
//  ViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        fetchData()
        
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchData() {
//        APICaller.shared.getNewReleases(completion: { (result) in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                print("getNewReleases: ", error.localizedDescription)
//            }
//        })
        
//        APICaller.shared.getFeaturedPlaylists { (result) in
//            switch result {
//            case .success(_):
//                break
//            case .failure(let error):
//                print("getFeaturedPlaylists: ", error.localizedDescription)
//            }
//        }
        
        APICaller.shared.getRecommendationGenres { (result) in
            switch result {
            case .success(let model):
                let genres = model.genres
                // get random genre from recommended genres
                var seeds = Set<String>()
                while seeds.count < 3  {
                    if let randomGenre = genres.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { (recommendedResult) in
                    switch recommendedResult {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("getRecommendations: ", error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print("getRecommendationGenres: ",error.localizedDescription)
            }
        }
        
        
        
        
    }


}

