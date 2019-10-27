import os.log
import RealmSwift
import SnapKit
import UIKit

class BadgeDetailViewController: DetailViewController {
    
    // MARK: - Init
    
    init(badge: Badge, indexPath: IndexPath, delegate: CompletableDelegate, realm: Realm) {
        super.init(notesSection: 1, indexPath: indexPath, entity: badge, delegate: delegate, realm: realm)
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

extension BadgeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Notes" : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CompleteTableViewCell
            cell.setup(completable: entity, indexPath: entityIndexPath, delegate: delegate)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as NotesTableViewCell
            cell.setup(notable: entity, delegate: self)
            return cell
        default:
            fatalError("Out of range")
        }
    }
    
}
