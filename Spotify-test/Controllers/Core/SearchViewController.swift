//
//  SearchViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, artists, albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                         leading: 7.5,
                                                         bottom: 0,
                                                         trailing: 7.5)
            
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(110)
                ),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 7.5,
                                                         leading: 10,
                                                         bottom: 7.5,
                                                         trailing: 10)
            
            return NSCollectionLayoutSection(group: group)
            
        }))
    
    // MARK: - LifeCycle
    
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.delegate = self
        
        
        navigationItem.searchController = searchController
          
        view.addSubview(collectionView)
        
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        
        
        // Categories
        APICaller.shared.getCategories { [weak self](result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
//                    let first = categories.first!
                    self?.categories = categories
                    self?.collectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else  {
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.search(withQuery: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultsController.update(withResults: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    
    
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode =  .never
            navigationController?.pushViewController(vc, animated: true)
        case .artist(let model):
//            print(model.external_urls)
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            
//            let vc = SFSafariViewController(url: url)
//            present(vc, animated: true, completion: nil)
            let vc = WebViewController()
            vc.artistURL = url
//            present(vc, animated: true, completion: nil)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = model.name
            navigationController?.pushViewController(vc, animated: true)
            
        
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode =  .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(fromVC: self, track: model)
        }
    }
}

 
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.identifer,
                for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        
        cell.configure(withModel: CategoryCollectionViewCellViewModel(
                        title: category.name,
                        icons: URL(string: category.icons.first?.url ?? "")))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
