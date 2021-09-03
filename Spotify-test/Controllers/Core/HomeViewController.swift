//
//  ViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])                    //0
    case featuredPlaylists(viewModels: [FeaturedPlaylistsCellViewModel])        //1
    case recommmendedTracks(viewModels: [RecommendedTracksCellViewModel])       //2
    case recentlyPlayedTracks(viewModels: [RecentPlayedTracksCellViewModel])    //3
    case currentUserPlaylists(viewModels: [CurrentUserPlaylistsCellViewModel])  //4
    
    var title: String {
        switch self {
        case .newReleases:
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                return "Good morning"
            case 12:
                return "Good noon"
            case 13..<17:
                return "Good afternoon"
            case 17..<22:
                print(NSLocalizedString("Evening", comment: "Evening"))
                return "Good evening"
            default:
                return "Good night"
            }
        //return "New Releases for you"
        case .featuredPlaylists:
            return "Featured playlists"
        case .recommmendedTracks:
            return "Random tracks"
        case .recentlyPlayedTracks:
            return "Recently played"
        case .currentUserPlaylists:
            return "Your playlists"
        }
    }
}

class HomeViewController: UIViewController {
    private var newReleasedAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    private var recentTracks: [RecentTracks] = []
    private var userPlaylists: [Playlist] = []
    
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
    
    private var sections = [BrowseSectionType]()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.random().cgColor, UIColor.systemBackground]
        gradient.colors = [UIColor.systemGray.cgColor, UIColor.systemBackground]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.3, y: 1.0)
        
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(gradient)
        
        
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
        
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // gradient
        
        view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        gradient.frame = CGRect(x: 0,
                                y: 0-view.safeAreaInsets.top,
                                width: view.width,
                                height: view.height/4)
        
        collectionView.layer.insertSublayer(gradient, at: 0)
        
        
        collectionView.frame = view.bounds
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        print("point: \(touchPoint)")
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this to a playlist?",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = { playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { success in
                        print("Added to Playlist success: \(success)")
                    }
                }
                vc.title = "Select Playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register((RecentlyPlayedTracksCollectionViewCell.self), forCellWithReuseIdentifier: RecentlyPlayedTracksCollectionViewCell.identifier)
        
        
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        
        collectionView.register(UserPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: UserPlaylistsCollectionViewCell.identifier)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsReponse?
        var recommedations: RecommendationsResponse?
        var recentTracks: RecentlyPlayedTracksResponse?
        
        var currentUserPlaylists: [Playlist]?
        
        // New Releases
        APICaller.shared.getNewReleases(completion: { (result) in
            // defer, whenever this ApiCall is completed, decrement the number of dispatchGroup entries
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print("getNewReleases: ", error.localizedDescription)
            }
        })
        
        // Featured playlist
        APICaller.shared.getFeaturedPlaylists { (result) in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylists = model
            case .failure(let error):
                print("getFeaturedPlaylists: ", error.localizedDescription)
            }
        }
        
        // Recommended Genres
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
                
                // Recommended tracks
                APICaller.shared.getRecommendations(genres: seeds) { (recommendationResult) in
                    defer {
                        dispatchGroup.leave()
                    }
                    switch recommendationResult {
                    case .success(let model):
                        recommedations = model
                    case .failure(let error):
                        print("getRecommendations: ", error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("getRecommendationGenres: ",error.localizedDescription)
            }
        }
        
        // User's Recently played tracks
        APICaller.shared.getRecentPlayedTracks { (result) in
            defer {
                dispatchGroup.leave()
            }
            
            switch result {
            case .success(let model):
                recentTracks = model
            case .failure(let error):
                print("getRecentPlayedTracks: ", error.localizedDescription)
            }
        }
        
        // CurrentUser playlists
        APICaller.shared.getCurrentUserPlaylists { ( result ) in
            defer {
                dispatchGroup.leave()
            }

            switch result {
            case .success(let playlists):
                currentUserPlaylists = playlists
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let newReleasedAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let recommendedTracks = recommedations?.tracks,
                  let recentTracks = recentTracks?.items,
                  let userPlaylists = currentUserPlaylists
            else {
                return
            }
            
            self.configureModels(newAlbums: newReleasedAlbums, playlists: playlists, tracks: recommendedTracks, recentTracks: recentTracks, userPlaylists: userPlaylists)
        }
        
    }
    
    
    private func configureModels(newAlbums: [Album],
                                 playlists: [Playlist],
                                 tracks: [AudioTrack],
                                 recentTracks: [RecentTracks],
                                 userPlaylists: [Playlist]) {
        self.newReleasedAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        self.recentTracks = recentTracks
        self.userPlaylists = userPlaylists
        //        print(newAlbums.count)
        //        print(playlists.count)
        //        print(tracks.count)
        //        print(userPlaylists.count)
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? ""
            )
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistsCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.tracks.total,
                creatorName: $0.description
            )
        })))
        sections.append(.recommmendedTracks(viewModels: tracks.compactMap({
            return RecommendedTracksCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""),
                artistName: $0.artists.first?.name ?? "-",
                track_number: $0.track_number
            )
        })))
        sections.append(.recentlyPlayedTracks(viewModels: recentTracks.compactMap({
            return RecentPlayedTracksCellViewModel(
                name: $0.track.name,
                artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""),
                artistName: $0.track.artists.first?.name ?? "-",
                track_number: $0.track.track_number)
        })))
        sections.append(.currentUserPlaylists(viewModels: userPlaylists.compactMap({
            return CurrentUserPlaylistsCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? "-"),
                numberOfTracks: $0.tracks.total,
                creatorName: $0.owner.display_name)
        })))
        
        collectionView.reloadData()
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
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommmendedTracks(let viewModels):
            return viewModels.count
        case .recentlyPlayedTracks(let viewModels):
            return viewModels.count
        case .currentUserPlaylists(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(withModel: viewModel)
            return cell
            
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(withModel: viewModel)
            return cell
            
        case .recommmendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(withModel: viewModel)
            return cell
            
        case .recentlyPlayedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPlayedTracksCollectionViewCell.identifier, for: indexPath) as? RecentlyPlayedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(withModel: viewModel)
            return cell
            
        case .currentUserPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPlaylistsCollectionViewCell.identifier, for: indexPath) as? UserPlaylistsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(withModel: viewModel)
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        case .newReleases:
            let album = newReleasedAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .featuredPlaylists:
            let playlist =  playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recommmendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(fromVC: self, track: track)
            
        case .recentlyPlayedTracks:
            let recentTrack = recentTracks[indexPath.row].track
            PlaybackPresenter.shared.startPlayback(fromVC: self, track: recentTrack)
            
        case .currentUserPlaylists:
            let uPlaylists =  userPlaylists[indexPath.row]
            let vc = PlaylistViewController(playlist: uPlaylists)
            vc.title = uPlaylists.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let modelTitle = sections[section].title
        
        header.configure(withTitle: modelTitle)
        return header
        
    }
    
    
}

extension HomeViewController {
    // Collection View Layout - Compositional Layout
    
    /// Create Section Layout
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection? {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
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
            
            section.boundarySupplementaryItems = supplementaryViews
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
                    widthDimension: .absolute(190*0.80),
                    heightDimension: .absolute(190)
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
            
            section.boundarySupplementaryItems = supplementaryViews
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
                    widthDimension: .absolute(150*0.80),
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
            
            section.boundarySupplementaryItems = supplementaryViews
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
                    widthDimension: .absolute(190*0.80),
                    heightDimension: .absolute(190)
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
            
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 4:
            
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
            
            section.boundarySupplementaryItems = supplementaryViews
            
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
            
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
