import UIKit

class RankDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var rank: Rank!
    
    // MARK: - Init
    
    init(rank: Rank) {
        super.init(nibName: nil, bundle: nil)
        self.rank = rank
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = rank.name
        
        view.backgroundColor = .white
    }
}
