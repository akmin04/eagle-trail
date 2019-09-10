import UIKit

@objc protocol Favoritable {
    @objc func onFavoriteToggle()
}

protocol FavoriteDelegate {
    func toggleFavorite(indexPath: IndexPath)
}
