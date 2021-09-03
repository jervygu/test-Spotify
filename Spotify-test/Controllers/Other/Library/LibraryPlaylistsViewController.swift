//
//  LibraryPlaylistsViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var playlists = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        setUpNoPlaylistView()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(
            x: 0,
            y: 0,
            width: 150,
            height: 150)
        
        noPlaylistsView.center = view.center
        
        tableView.frame = view.bounds
    }
    
    private func setUpNoPlaylistView() {
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.delegate = self
        
        noPlaylistsView.configure(
            withViewModel: ActionLabelViewViewModel(
                text: "You don't have any playlists",
                actionTitle: "Create"
            )
        )
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            // showl label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            // show table
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    public func showCreatePlaylistAlert() {
        // show creation UI
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter playlist name.",
            preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (_) in
            
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylist(withName: text) { (success) in
                if success {
                    HapticsManager.shared.vibrate(forType: .success)
                    //  refresh list of playlist
                    self.fetchData()
                } else {
                    HapticsManager.shared.vibrate(forType: .error)
                    print("Failed to create playlist.")
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(withViewModel: SearchResultSubtitleTableViewCellViewModel(
                        title: playlist.name,
                        subTitle: "by \(playlist.owner.display_name)",
                        imageURL: URL(string: playlist.images.first?.url ?? "")))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
