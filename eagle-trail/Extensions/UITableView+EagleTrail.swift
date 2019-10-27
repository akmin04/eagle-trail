import UIKit

extension UITableView {
    
    static func initInsetGrouped() -> UITableView {
        if #available(iOS 13.0, *) {
            return UITableView(frame: .zero, style: .insetGrouped)
        } else {
            return UITableView()
        }
    }
    
}
