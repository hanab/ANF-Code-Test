//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    private var exploreData: [ExploreItem]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let jsonDictionary = try? JSONDecoder().decode([ExploreItem].self, from: fileContent) {
            return jsonDictionary
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ExploreItemTableViewCell.self, forCellReuseIdentifier: "exploreContentCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
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
