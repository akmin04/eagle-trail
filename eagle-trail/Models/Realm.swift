import RealmSwift

typealias Entity = Notable & Completable

protocol Completable where Self : Object {
    var isComplete: Bool { get set }
}

protocol Notable where Self : Object {
    var notes: String { get set }
}

protocol Badge: Notable, Completable {
    var name: String { get set }
    var requirements: List<Requirement> { get set }
}

class Requirement: Object, Notable, Completable {
    @objc dynamic var depth = 0
    @objc dynamic var index = ""
    @objc dynamic var text = ""
    @objc dynamic var parentRank: Rank? = nil
    @objc dynamic var parentMeritBadge: MeritBadge? = nil
    @objc dynamic var notes = ""
    @objc dynamic var isComplete = false
}

class Rank: Object, Badge{
    @objc dynamic var name = ""
    var requirements = List<Requirement>()
    @objc dynamic var notes = ""
    @objc dynamic var isComplete = false
}

class MeritBadge: Object, Badge{
    @objc dynamic var name = ""
    var requirements = List<Requirement>()
    @objc dynamic var notes = ""
    @objc dynamic var isComplete = false
    @objc dynamic var favoriteIndex = -1
    @objc dynamic var isEagle = false
}
