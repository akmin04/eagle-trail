import os.log
import RealmSwift
import SnapKit
import UIKit

class RequirementDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var realm: Realm!
    
    private var requirement: Requirement!
    
    private var noteEdited = false
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return tapGesture
    }()
    
    private lazy var tableView: UITableView = {
        var tableView: UITableView!
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(RequirementTableViewCell.self)
        tableView.registerReusableCell(NotesTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Init
    
    init(requirement: Requirement, realm: Realm) {
        super.init(nibName: nil, bundle: nil)
        self.requirement = requirement
        self.realm = realm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = requirement.index
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
            if let text = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? NotesTableViewCell)?.notesTextView.text {
                requirement.notes = text
            } else {
                os_log("IndexPath (0, 1) is not NotesTableViewCell")
            }
        }
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? NotesTableViewCell)?.notesTextView.resignFirstResponder()
    }
    
}



extension RequirementDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension RequirementDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Notes"
        default:
            fatalError("No section past 1")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as RequirementTableViewCell
            cell.setup(requirement: requirement, indexPath: indexPath, delegate: nil)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as NotesTableViewCell
            cell.setup(requirement: requirement, delegate: self)
            return cell
        default:
            fatalError("No section past 1")
        }
    }
    
}

extension RequirementDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        noteEdited = true
        tableView.beginUpdates()
        tableView.endUpdates()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
}

extension RequirementDetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        cancelled()
    }
    
}
