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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
        
        view.addSubview(tableView)
        view.addGestureRecognizer(tapGesture)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
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
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollToRow(at: IndexPath(row: 0, section: notesSection), at: .bottom, animated: true)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        print("hide")
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
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
