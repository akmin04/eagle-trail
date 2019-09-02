import RealmSwift
import SnapKit
import UIKit

class RankDetailViewController: RequirementsTableViewController {
    
    // MARK: - Init
    
    init(rank: Rank, realm: Realm) {
        super.init(name: rank.name, requirements: Array(rank.requirements), realm: realm)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
