import RealmSwift
import SnapKit
import SwiftyJSON
import UIKit
import os.log

class RequirementsTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var name: String!
    private var requirements: [(requirement: Requirement, isHidden: Bool)]!
    private var realm: Realm!
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(RequirementTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Init
    
    init(name: String, requirements: [Requirement], realm: Realm) {
        super.init(nibName: nil, bundle: nil)
        
        self.name = name
        self.requirements = requirements.map { ($0, false) }
        self.realm = realm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        for (i, requirement) in requirements.enumerated() {
            if !requirement.isHidden && requirement.requirement.isComplete {
                hideCompleted(indexPath: IndexPath(row: i, section: 0))
            }
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - Private Methods
    
    private func hideCompleted(indexPath: IndexPath) {
        let requirement = requirements[indexPath.row].requirement
        var index = indexPath.row + 1
        
        while index < requirements.count && requirements[index].requirement.depth > requirement.depth {
            index += 1
        }
            
        for i in (indexPath.row + 1)..<index {
            requirements[i].isHidden = requirement.isComplete
        }
        
        tableView.reloadRows(
            at: Array(indexPath.row..<index).map { IndexPath(row: $0, section: indexPath.section) },
            with: .automatic
        )
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
        cell.setup(requirement: requirements[indexPath.row].requirement, indexPath: indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.requirements[indexPath.row].isHidden {
            return 0
        }
        return UITableView.automaticDimension
    }
}

extension RequirementsTableViewController: RequirementCellDelegate {
    
    func longPress(indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let requirement = self.requirements[indexPath.row].requirement
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: requirement.isComplete ? "Not Complete" : "Complete", style: .default, handler: { (_) in
            try! self.realm.write {
                requirement.isComplete = !requirement.isComplete
            }
            
            self.hideCompleted(indexPath: indexPath)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
