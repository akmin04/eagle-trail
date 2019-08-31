import SnapKit
import UIKit

class RequirementTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var reqTextLabel: UILabel!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var spacerViewWidth: NSLayoutConstraint!
    
    // MARK: - Public Methods
    
    func setup(requirement: Requirement) {
        indexLabel.text = "\(requirement.index)"
        reqTextLabel.text = requirement.text
        spacerViewWidth.constant = CGFloat(16 + (32 * requirement.depth))
        spacerView.layoutIfNeeded()
    }
}
