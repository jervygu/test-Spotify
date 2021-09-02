//
//  ViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommmendedTracks
    case currentUserPlaylists
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Releases for you"
        case .featuredPlaylists:
            return "Featured playlists"
        case .recommmendedTracks:
            return "Recommended tracks"
        case .currentUserPlaylists:
            return "Your playlists"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        // Collection View Layout - Compositional Layout
        
        // New Releases
        
//        APICaller.shared.getNewReleases(completion: { (result) in
//            switch result {
//            case .success(let model):
//                break
//            case .failure(let error):
//                print("getNewReleases: ", error.localizedDescription)
//            }
//        })
        
        
        
        // Featured playlist
        
//        APICaller.shared.getFeaturedPlaylists { (result) in
//            switch result {
//            case .success(_):
//                break
//            case .failure(let error):
//                print("getFeaturedPlaylists: ", error.localizedDescription)
//            }
//        }
        
        // Recommended tracks
        
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
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemRed
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemBlue
        } else if indexPath.section == 2 {
            cell.backgroundColor = .systemOrange
        } else if indexPath.section == 3 {
            cell.backgroundColor = .systemGreen
        }
        
        return cell
    }
    
}

extension HomeViewController {
    
    /// Create Section Layout
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection? {
        switch section {
        case 0:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 3,
                                                         leading: 3,
                                                         bottom: 3,
                                                         trailing: 3)
            
            // Group
            // vertical group inside horizontal group
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200)
                ),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.475),
                    heightDimension: .absolute(200)
                ),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 10,
                bottom: 0,
                trailing: 10)
            
//            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 5,
                bottom: 5,
                trailing: 5)
            
            // Group
            // vertical group inside horizontal group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(210*0.70),
                    heightDimension: .absolute(210)
                ),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 8,
                bottom: 0,
                trailing: 8)
            
//            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 5,
                bottom: 5,
                trailing: 5)
            
            // Group
            // vertical group inside horizontal group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150*0.70),
                    heightDimension: .absolute(150)
                ),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 8,
                bottom: 0,
                trailing: 8)
            
//            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 3:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 5,
                bottom: 5,
                trailing: 5)
            
            // Group
            // vertical group inside horizontal group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(170*0.70),
                    heightDimension: .absolute(170)
                ),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 8,
                bottom: 0,
                trailing: 8)
            
//            section.boundarySupplementaryItems = supplementaryViews
            return section
            
            
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
//            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
