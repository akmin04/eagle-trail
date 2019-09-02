import UIKit

extension UIImage {
    
    static var favorite: UIImage { return UIImage(named: "favorite")! }
    
    static var rank: UIImage { return UIImage(named: "rank")! }
    
    static var meritBadge: UIImage { return UIImage(named: "merit-badge")! }
    
    static func rankBadge(name: String) -> UIImage {
        return UIImage(named: name.lowercased().replacingOccurrences(of: " ", with: "-"))!
    }
    
}
