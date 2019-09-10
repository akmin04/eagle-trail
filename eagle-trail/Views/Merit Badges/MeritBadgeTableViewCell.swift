import UIKit

class MeritBadgeTableViewCell: UITableViewCell, Reusable, Favoritable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    
    private var delegate: FavoriteDelegate!
    private var indexPath: IndexPath!
    
    // MARK: - Methods
    
    func setup(meritBadge: MeritBadge, indexPath: IndexPath, delegate: FavoriteDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        favoriteButton.addTarget(self, action: #selector(onFavoriteToggle), for: .touchUpInside)
        
        nameLabel.attributedText = NSAttributedString(
            string: meritBadge.name,
            attributes: [NSAttributedString.Key.strikethroughStyle : (meritBadge.isComplete ? 2 : 0)]
        )
        if meritBadge.favoriteIndex == -1 {
            favoriteButton.tintColor = .lightGray
        } else {
            favoriteButton.tintColor = .systemBlue
        }
    }
    
    @objc func onFavoriteToggle() {
        delegate.toggleFavorite(indexPath: indexPath)
    }
    
}
