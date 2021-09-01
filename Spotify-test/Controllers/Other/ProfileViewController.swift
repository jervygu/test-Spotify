//
//  ProfileViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import UIKit
import SDWebImage

struct ProfileData {
    let title: String
    let value: String
}

class ProfileViewController: UIViewController {
    
    private var models = [ProfileData]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchUserProfile()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchUserProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        // configure table with model
        
        models.append(ProfileData(title: "Fullname", value: model.display_name))
        title = model.display_name
        models.append(ProfileData(title: "Email", value: model.email))
        models.append(ProfileData(title: "User ID", value: model.id))
        
        guard let ff = model.followers?.total else {
            return
        }
        models.append(ProfileData(title: "Followers", value: String(ff)))
        models.append(ProfileData(title: "Following", value: "1M"))
        models.append(ProfileData(title: "Plan", value: model.product))
//        models.append("Following: \(model.following?.artists.total)")
//        models.append("Plan: \(model.product)")
        
        createTableHeader(with: model.images.first?.url)
        
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String? ) {
        guard let urlString = string,
              let url = URL(string: urlString) else {
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.textLabel?.text = models[indexPath.row].title
        cell.configure(with: ProfileData(title: models[indexPath.row].title,
                                         value: models[indexPath.row].value))
        cell.selectionStyle = .none
        return cell
    }
    
    
}
