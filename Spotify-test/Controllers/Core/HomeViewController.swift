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
        
//        (genres: ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"])
        
        APICaller.shared.getRecommendationGenres { (result) in
            switch result {
            case .success(let model):
                // get random genre from recommended genres
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 3  {
                    if let randomGenre = genres.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }
                
//                let myGenre: Set<String> = ["electro","philippines-opm", "pop","sleep", "garage"]
                
                APICaller.shared.getRecommendations(genres: seeds) { (recommendationResult) in
                    switch recommendationResult {
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

