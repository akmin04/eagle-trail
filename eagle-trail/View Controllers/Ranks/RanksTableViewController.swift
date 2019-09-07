import os.log
import RealmSwift
import SnapKit
import SwiftyJSON
import UIKit

class RanksTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var realm: Realm!
    
    private var ranks: [Rank]!
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(RankTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Init
    
    init(realm: Realm, preload: JSON?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Ranks", image: UIImage.rank, tag: 0)
        
        self.realm = realm
        
        if let preload = preload {
            os_log("Loading rank preload", type: .info)
            
            for data in preload["ranks"].arrayValue {
                try! realm.write {
                    let rank = Rank()
                    rank.name = data["name"].stringValue
                    
                    for data in data["requirements"].arrayValue {
                        let requirement = Requirement()
                        requirement.depth = data["depth"].intValue
                        requirement.index = data["index"].stringValue
                        requirement.text = data["text"].stringValue
                        if requirement.depth == 0 {
                            requirement.parentRank = rank
                        }
                        rank.requirements.append(requirement)
                    }
                    realm.add(rank)
                }
            }
        }
        
        ranks = Array(realm.objects(Rank.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ranks"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

extension RanksTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(RankDetailViewController(rank: ranks[indexPath.row], realm: realm), animated: true)
    }
    
}

extension RanksTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as RankTableViewCell
        cell.setup(rank: ranks[indexPath.row])
        return cell
    }
    
}
