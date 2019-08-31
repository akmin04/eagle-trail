import UIKit
import SnapKit

class RankDetailViewController: RequirementsTableViewController {
    
    // MARK: - Init
    
    init(rank: Rank) {
        super.init(name: rank.name, requirements: Array(rank.requirements))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
