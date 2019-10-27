import UIKit

class CompleteTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var completeSwitch: UISwitch!
    
    // MARK: - Private Properties
    
    private var delegate: CompletableDelegate?
    private var indexPath: IndexPath!
    
    // MARK: - Methods
    
    func setup(completable: Completable, indexPath: IndexPath, delegate: CompletableDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        completeSwitch.isOn = completable.isComplete
        completeSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    @objc func switchToggled() {
        delegate?.completeToggled(at: indexPath)
    }
    
}
