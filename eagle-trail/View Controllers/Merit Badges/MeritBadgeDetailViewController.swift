import UIKit
import SnapKit

class MeritBadgeDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var meritBadge: MeritBadge!
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Init
    
    init(meritBadge: MeritBadge) {
        super.init(nibName: nil, bundle: nil)
        self.meritBadge = meritBadge
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = meritBadge.name
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}
