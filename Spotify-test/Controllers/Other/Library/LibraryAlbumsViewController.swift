//
//  LibraryAlbumsViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
//        view.backgroundColor = .green
        
        setUpNoAlbumView()
        fetchData()
        
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] (_) in
                self?.fetchData()
                
            })
        
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(
            x: (view.width-150)/2,
            y: (view.height-150)/2,
            width: 150,
            height: 150)
        
        tableView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height)
    }
    
    private func setUpNoAlbumView() {
        view.addSubview(noAlbumsView)
        
        noAlbumsView.delegate = self
        
        noAlbumsView.configure(
            withViewModel: ActionLabelViewViewModel(
                text: "You have not saved albums yet.",
                actionTitle: "Browse"
            )
        )
    }
    
    private func fetchData() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if albums.isEmpty {
            // showl label
//            noAlbumsView.backgroundColor = .red
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            // show table
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }

}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
        
        let album = albums[indexPath.row]
        
        cell.configure(withViewModel: SearchResultSubtitleTableViewCellViewModel(
                        title: album.name,
                        subTitle: "by \(album.artists.first?.name ?? "-")",
                        imageURL: URL(string: album.images.first?.url ?? "")))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
