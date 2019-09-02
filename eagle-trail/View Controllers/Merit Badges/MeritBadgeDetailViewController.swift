import RealmSwift
import SnapKit
import UIKit

class MeritBadgeDetailViewController: RequirementsTableViewController {
    
    // MARK: - Init
    
    init(meritBadge: MeritBadge, realm: Realm) {
        super.init(name: meritBadge.name, requirements: Array(meritBadge.requirements), realm: realm)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
