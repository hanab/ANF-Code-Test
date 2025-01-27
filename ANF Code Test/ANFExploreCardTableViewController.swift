//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    
    // MARK: Properties
    var exploreItemsManager: ExploreManagerProtocol = ExploreManager(session: URLSession.shared)
    var exploreData: [ExploreItem]?
    var images = [UIImage?]()
    
    // MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ExploreItemTableViewCell.self, forCellReuseIdentifier: "exploreContentCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        // Used to fetech data eveytime the app is active
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataWhenAppIsActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        exploreItemsManager.fetchAllExploreItems { [weak self ] exploreItems in
            self?.exploreData = exploreItems
            self?.loadImagesForItems()
        }
    }
    
    // MARK: deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: tableview data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "exploreContentCell", for: indexPath) as? ExploreItemTableViewCell else {
            return UITableViewCell()
        }
        if let exploreItems = exploreData {
            cell.updateWith(exploreItem: exploreItems[indexPath.row])
            cell.backgroundImageView.image = images[indexPath.row]
        }
        return cell
    }
    
    // MARK: methods
    @objc func fetchDataWhenAppIsActive() {
        exploreItemsManager.fetchAllExploreItems { [weak self ] exploreItems in
            self?.exploreData = exploreItems
            DispatchQueue.main.async {
                self?.loadImagesForItems()
            }
        }
    }
    
    // Used because the tablview reloads before the images finishe downloading
    // using SDWebImage or Kingfisher could be a better solution
    func loadImagesForItems() {
        guard let exploreData = exploreData else { return}
        let totalItems = exploreData.count
        images = Array(repeating: UIImage(named: "ANF-2024-060624-M-HP-NewArrivals-USCA-Mens"), count: totalItems)
        for (index, item) in exploreData.enumerated() {
            loadImageUsingCacheWithURLString(item.backgroundImage) { [weak self] image in
                guard let self = self else { return }
                
                // Update the item with the downloaded image
                images[index] = image
                // If all images are downloaded, reload the table
                if self.images.count == totalItems {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
