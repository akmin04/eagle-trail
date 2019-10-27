import os.log
import RealmSwift
import SnapKit
import UIKit

private typealias CellType = (type: UITableViewCell.Type, section: Int, row: Int)

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    internal var notesSection: Int!
    internal var entityIndexPath: IndexPath?
    internal var entity: Entity!
    
    internal var delegate: CompletableDelegate?
    internal var realm: Realm!
    
    internal var noteEdited = false
    
    internal lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return tapGesture
    }()
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView.initInsetGrouped()
        tableView.delegate = self
        return tableView
    }()
    
    private var notesCell: NotesTableViewCell {
        return tableView.cellForRow(at: IndexPath(row: 0, section: notesSection)) as! NotesTableViewCell
    }
    
    // MARK: - Init
    
    init(notesSection: Int, indexPath: IndexPath?, entity: Entity, delegate: CompletableDelegate?, realm: Realm) {
        super.init(nibName: nil, bundle: nil)
        
        self.notesSection = notesSection
        self.entityIndexPath = indexPath
        self.entity = entity
        self.delegate = delegate
        self.realm = realm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelled))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        view.addSubview(tableView)
        view.addGestureRecognizer(tapGesture)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func cancelled() {
        if noteEdited {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(
                title: "Discard Changes",
                style: .destructive,
                handler: { _ in self.dismiss(animated: true) }
            ))
            alertController.addAction(UIAlertAction(
                title: "Keep Editing",
                style: .cancel,
                handler: nil
            ))
            present(alertController, animated: true, completion: nil)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func done() {
        try! realm.write {
            entity.notes = notesCell.notesTextView.text
        }
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        notesCell.notesTextView.resignFirstResponder()
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        noteEdited = true
        tableView.beginUpdates()
        tableView.endUpdates()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
}

extension DetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        cancelled()
    }
    
}
