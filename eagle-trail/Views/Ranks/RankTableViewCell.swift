import UIKit

class RankTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    // MARK: - Public Methods
    
    func setup(rank: Rank) {
        nameLabel.text = rank.name
        badgeImageView.image = UIImage.rankBadge(name: rank.name)
    }
    
}
