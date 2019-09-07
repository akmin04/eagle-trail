import os.log
import RealmSwift
import SnapKit
import SwiftyJSON
import UIKit

class RequirementsTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var realm: Realm!
    private var name: String!
    
    private var requirements: [(requirement: Requirement, isHidden: Bool)]!
    
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
        navigationItem.largeTitleDisplayMode = .never
        
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
    
    private func getChildren(at indexPath: IndexPath) -> [IndexPath] {
        let requirement = requirements[indexPath.row].requirement
        var index = indexPath.row + 1
        
        while index < requirements.count && requirements[index].requirement.depth > requirement.depth {
            index += 1
        }
        
        return ((indexPath.row + 1)..<index).map { IndexPath(row: $0, section: indexPath.section) }
    }
    
    private func hideCompleted(indexPath: IndexPath) {
        let childrenIndices = getChildren(at: indexPath)
        for i in childrenIndices {
            requirements[i.row].isHidden = requirements[indexPath.row].requirement.isComplete
        }
        tableView.reloadRows(at: [indexPath] + childrenIndices, with: .automatic)
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

extension RequirementsTableViewController: LongPressDelegate {
    
    func longPress(at indexPath: IndexPath) {
        let requirement = self.requirements[indexPath.row].requirement
        
        try! self.realm.write {
            requirement.isComplete = !requirement.isComplete
            
            // Update parent rank/merit badge if all top-level requirements are complete.
            let allComplete = self.requirements
                .filter { !$0.requirement.isComplete && $0.requirement.depth == 0}
                .count == 0
            if let rank = requirement.parentRank {
                rank.isComplete = allComplete
            }
            if let meritBadge = requirement.parentMeritBadge {
                meritBadge.isComplete = allComplete
            }
            
            // If the requirement was changed to not complete, mark all its children as not complete.
            if !requirement.isComplete {
                getChildren(at: indexPath).forEach {
                    self.requirements[$0.row].requirement.isComplete = false
                }
            }
        }
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.hideCompleted(indexPath: indexPath)
    }
    
}
