import UIKit

// http://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib? { return UINib(nibName: reuseIdentifier, bundle: nil) }
}
