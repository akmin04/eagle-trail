import UIKit

class MeritBadgeTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    
    private var delegate: Favoritable!
    private var indexPath: IndexPath!
    
    // MARK: - Methods
    
    func setup(meritBadge: MeritBadge, indexPath: IndexPath, delegate: Favoritable) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        favoriteButton.addTarget(self, action: #selector(onFavoriteButtonPress), for: .touchUpInside)
        
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
    
    @objc func onFavoriteButtonPress() {
        delegate.toggleFavorite(indexPath: indexPath)
    }
    
}
