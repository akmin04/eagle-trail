import UIKit
import SnapKit
import SwiftyJSON
import os.log

class RequirementsTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var name: String!
    private var requirements: [Requirement]!
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(RequirementTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Init
    
    init(name: String, requirements: [Requirement]) {
        super.init(nibName: nil, bundle: nil)
        
        self.name = name
        self.requirements = requirements
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

extension RequirementsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension RequirementsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as RequirementTableViewCell
        cell.setup(requirement: requirements[indexPath.row])
        return cell
    }
    
}
