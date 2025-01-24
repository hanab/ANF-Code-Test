//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    // MARK: Properties
    var exploreItemsManager: ExploreManagerProtocol = ExploreManager(session: URLSession.shared)
    var exploreData: [ExploreItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ExploreItemTableViewCell.self, forCellReuseIdentifier: "exploreContentCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataWhenAppIsActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        exploreItemsManager.fetchAllExploreItems { [weak self ] exploreItems in
            self?.exploreData = exploreItems
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func fetchDataWhenAppIsActive() {
        exploreItemsManager.fetchAllExploreItems { [weak self ] exploreItems in
            self?.exploreData = exploreItems
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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
        }
        return cell
    }
}
