import UIKit

class RankTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    // MARK: - Methods
    
    func setup(rank: Rank) {
        nameLabel.attributedText = NSAttributedString(
            string: rank.name,
            attributes: [NSAttributedString.Key.strikethroughStyle : (rank.isComplete ? 2 : 0)]
        )
        badgeImageView.image = UIImage.rankBadge(name: rank.name)
    }
    
}
