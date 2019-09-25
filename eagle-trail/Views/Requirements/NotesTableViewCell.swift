import UIKit

class NotesTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Methods
    
    func setup(requirement: Requirement, delegate: UITextViewDelegate?) {
        notesTextView.text = requirement.notes
        notesTextView.delegate = delegate
    }
    
}
