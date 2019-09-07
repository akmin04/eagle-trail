import SnapKit
import UIKit

class RequirementTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var reqTextLabel: UILabel!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var spacerViewWidth: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var delegate: LongPressDelegate!
    private var indexPath: IndexPath!
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(onLongPress))
        return longPressGesture
    }()
    
    // MARK: - Methods
    
    func setup(requirement: Requirement, indexPath: IndexPath, delegate: LongPressDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        addGestureRecognizer(longPressGesture)
        
        reqTextLabel.text = [
            requirement.index,
            requirement.index == "" ? "" : ") ",
            requirement.isComplete ? "Complete" : requirement.text
        ].joined()
        spacerViewWidth.constant = CGFloat(16 * requirement.depth)
        spacerView.layoutIfNeeded()
    }
    
    @objc func onLongPress() {
        if longPressGesture.state == .began {
            delegate.longPress(at: indexPath)
        }
    }
    
}
