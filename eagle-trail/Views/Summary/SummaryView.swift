import RealmSwift
import UIKit

class SummaryView: UIView, Reusable, Completable {

    // MARK: - Interface Builder
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var allCompleteButton: UIButton!
    @IBOutlet weak var notCompleteButton: UIButton!
    
    // MARK: - Private Properties
    
    private var badge: Badge!
    private var token: NotificationToken!
    private var delegate: CompleteDelegate!
    
    // MARK: - Init
    
    init(badge: Badge, delegate: CompleteDelegate) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.badge = badge
        self.token = badge.observe { change in
            self.update()
        }
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(Self.reuseIdentifier, owner: self, options: nil)
        
        allCompleteButton.addTarget(self, action: #selector(onAllComplete), for: .touchUpInside)
        notCompleteButton.addTarget(self, action: #selector(onNotComplete), for: .touchUpInside)
        
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - Methods
    
    func update() {
        let requirements = Array(badge.requirements.filter { $0.depth == 0})
        let completed = requirements.filter { $0.isComplete }.count
        let total = requirements.count
        
        percentageLabel.text = "\(Int(round(Double(completed) / Double(total) * 100.0)))%"
        fractionLabel.text = "\(completed)/\(total)"
        progressView.progress = Float(completed) / Float(total)
    }
    
    // MARK: - Completable
    
    @objc func onAllComplete() {
        delegate.allCompleted()
        update()
    }
    
    @objc func onNotComplete() {
        delegate.notCompleted()
        update()
    }
}
