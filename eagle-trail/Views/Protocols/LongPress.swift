import UIKit

@objc protocol LongPressable {
    @objc func onLongPress()
}

protocol LongPressDelegate {
    func longPressed(at indexPath: IndexPath)
}

