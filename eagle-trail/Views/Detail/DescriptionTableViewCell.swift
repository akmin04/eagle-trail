import UIKit

class DescriptionTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var reqTextLabel: UITextView!
    
    // MARK: - Methods
    
    func setup(requirement: Requirement) {
        reqTextLabel.text = requirement.text
    }
    
}
