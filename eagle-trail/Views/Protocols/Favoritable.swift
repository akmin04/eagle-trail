import UIKit

@objc protocol Favoritable {
    @objc func onFavoriteToggle()
}

protocol FavoriteDelegate {
    func favoriteToggled(at indexPath: IndexPath)
}
