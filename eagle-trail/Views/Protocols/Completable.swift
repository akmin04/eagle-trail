import Foundation

@objc protocol Completable {
    @objc func onAllComplete()
    @objc func onNotComplete()
}

protocol CompleteDelegate {
    func allCompleted()
    func notCompleted()
}
