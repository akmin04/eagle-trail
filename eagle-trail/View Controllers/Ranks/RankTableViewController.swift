import UIKit
import SnapKit
import RealmSwift
import os.log

class RankTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var realm: Realm!
    
    private var ranks: [Rank]!
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.registerReusableCell(RankTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Init
    
    init(realm: Realm, preload: Preload?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Ranks", image: UIImage.rank, tag: 0)
        
        self.realm = realm
        
        if let preload = preload {
            os_log("Loading rank preload", type: .info)
            
            if let ranks = preload["ranks"] as? [AnyObject] {
                for data in ranks {
                    guard let data = data as? [String : AnyObject] else { continue }
                    
                    try! realm.write {
                        let rank = Rank()
                        rank.name = data["name"] as! String
                        realm.add(rank)
                    }
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
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

extension RankTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(RankDetailViewController(rank: ranks[indexPath.row]), animated: true)
    }
    
}

extension RankTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as RankTableViewCell
        cell.setup(rank: ranks[indexPath.row])
        return cell
    }
    
}
