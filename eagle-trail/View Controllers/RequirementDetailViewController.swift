import os.log
import RealmSwift
import SnapKit
import UIKit

class RequirementDetailViewController: DetailViewController {
    
    // MARK: - Init
    
    init(requirement: Requirement, indexPath: IndexPath, delegate: CompletableDelegate, realm: Realm) {
        super.init(notesSection: 2, indexPath: indexPath, entity: requirement, delegate: delegate, realm: realm)
        tableView.registerReusableCell(DescriptionTableViewCell.self)
        tableView.registerReusableCell(CompleteTableViewCell.self)
        tableView.registerReusableCell(NotesTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
}

extension RequirementDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 2 ? "Notes" : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DescriptionTableViewCell
            cell.setup(requirement: entity as! Requirement)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CompleteTableViewCell
            cell.setup(completable: entity, indexPath: entityIndexPath!, delegate: delegate!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as NotesTableViewCell
            cell.setup(notable: entity, delegate: self)
            return cell
        default:
            fatalError("Out of range")
        }
    }
    
}
