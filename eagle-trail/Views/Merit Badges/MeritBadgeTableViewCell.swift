import UIKit

protocol MeritBadgeCellDelegate {
    func toggleFavorite(indexPath: IndexPath)
}

class MeritBadgeTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate.toggleFavorite(indexPath: indexPath)
    }
    
    // MARK: - Private Properties
    
    private var delegate: MeritBadgeCellDelegate!
    private var indexPath: IndexPath!
    
    // MARK: - Public Methods
    
    func setup(meritBadge: MeritBadge, indexPath: IndexPath, delegate: MeritBadgeCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        update(meritBadge: meritBadge)
    }
    
    func update(meritBadge: MeritBadge) {
        nameLabel.text = meritBadge.name
        if meritBadge.favoriteIndex == -1 {
            favoriteButton.tintColor = .lightGray
        } else {
            favoriteButton.tintColor = .systemBlue
        }
    }
    
}
