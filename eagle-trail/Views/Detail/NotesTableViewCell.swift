import UIKit

class NotesTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Methods
    
    func setup(notable: Notable, delegate: UITextViewDelegate?) {
        notesTextView.text = notable.notes
        notesTextView.delegate = delegate
    }
    
}
