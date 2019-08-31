import UIKit
import SnapKit

class MeritBadgeDetailViewController: RequirementsTableViewController {
    
    // MARK: - Init
    
    init(meritBadge: MeritBadge) {
        super.init(name: meritBadge.name, requirements: Array(meritBadge.requirements))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
