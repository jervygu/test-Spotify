//
//  SearchResultsViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.isHidden = true
        
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource =  self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(withResults results: [SearchResult]) {
        
        let artists = results.filter({
            switch $0 {
            case .artist:
                return true
            default:
                return false
            }
        })
//        print(artists)
        
        let albums = results.filter({
            switch $0 {
            case .album:
                return true
            default:
                return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track:
                return true
            default:
                return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case.playlist:
                return true
            default:
                return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    
    // MARK: -  TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let songTxt = (album.total_tracks > 1) ? "songs" : "song"
            let formattedDate = String.formattedDateShort(string: album.release_date)
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                
                
                subTitle: "\(album.artists.first?.name ?? "") • \(formattedDate) • \(album.total_tracks) \(songTxt)",
                imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(withViewModel: viewModel)
            return cell
            
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            
            let type = artist.type
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                type: type.capitalizingFirstLetter(),
                imageURL: URL(string: artist.images?.first?.url ?? ""))
             
            cell.configure(withViewModel: viewModel)
            return cell
            
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let songTxt = (playlist.tracks.total > 1) ? "songs" : "song"
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subTitle: "by \(playlist.owner.display_name) • \(playlist.tracks.total) \(songTxt)",
                imageURL: URL(string: playlist.images.first?.url ?? "-"))
            cell.configure(withViewModel: viewModel)
            return cell
            
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            let formattedDate = String.formattedDateShort(string: track.album?.release_date ?? "")
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subTitle: "\(track.artists.first?.name ?? "-") • \(formattedDate)",
                imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(withViewModel: viewModel)
            return cell
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
