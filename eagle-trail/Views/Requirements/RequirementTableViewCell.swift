import SnapKit
import UIKit

protocol RequirementCellDelegate {
    func longPress(indexPath: IndexPath)
}

class RequirementTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var reqTextLabel: UILabel!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var spacerViewWidth: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var delegate: RequirementCellDelegate!
    private var indexPath: IndexPath!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    // MARK: - Public Methods
    
    func setup(requirement: Requirement, indexPath: IndexPath, delegate: RequirementCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        addGestureRecognizer(longPressGesture)
        
        update(requirement: requirement)
    }
    
    func update(requirement: Requirement) {
        reqTextLabel.text = [
            requirement.index,
            requirement.index == "" ? "" : ") ",
            requirement.isComplete ? "Complete" : requirement.text
        ].joined()
        spacerViewWidth.constant = CGFloat(16 * requirement.depth)
        spacerView.layoutIfNeeded()
    }
    
    @objc func longPress() {
        delegate.longPress(indexPath: indexPath)
    }
}
