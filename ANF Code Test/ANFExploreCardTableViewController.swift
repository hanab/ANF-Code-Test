//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    
    // MARK: Properties
    private var exploreManager: ExploreManagerProtocol?
    private var imageLoader: ImageLoaderProtocol?
    var exploreData: [ExploreItem]?
    var images = [UIImage?]()
    
    // MARK: intializer to make it testable
    static func vc(exploreManager: ExploreManagerProtocol = ExploreManager(session: URLSession.shared),
                   imageLoader: ImageLoaderProtocol = ImageLoader()) -> ANFExploreCardTableViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ANFExploreCardTableViewController") as! ANFExploreCardTableViewController
        viewController.exploreManager = exploreManager
        viewController.imageLoader = imageLoader
        return viewController
    }
    
    // MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ExploreItemTableViewCell.self, forCellReuseIdentifier: "exploreContentCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        // Used to fetech data eveytime the app is active
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchDataWhenAppIsActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    // MARK: deinit
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
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
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: methods
    @objc func fetchDataWhenAppIsActive() {
        exploreManager?.fetchAllExploreItems { [weak self ] exploreItems in
            self?.exploreData = exploreItems
            DispatchQueue.main.async {
                self?.loadImagesForItems()
            }
        }
    }
    
    // Used because the tableview reloads before the images finish downloading
    // reload the table only after all images are downloaded to avoid cell height issues in the first load
    // using SDWebImage or Kingfisher could be a better solution
    func loadImagesForItems() {
        guard let exploreData = exploreData else { return}
        let totalItems = exploreData.count
        images = Array(repeating: UIImage(named: "anf-20160527-app-m-shirts"), count: totalItems)
        var imagesLoaded = 0
        for (index, item) in exploreData.enumerated() {
            imageLoader?.loadImageUsingCacheWithURLString(item.backgroundImage) { [weak self] image in
                guard let self = self else { return }
                
                // Update the item with the downloaded image
                images[index] = image
                imagesLoaded += 1
                // If all images are downloaded, reload the table
                if imagesLoaded == totalItems {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
