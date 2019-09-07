import RealmSwift

protocol Badge where Self : Object {
    var name: String { get set }
    var requirements: List<Requirement> { get set }
}

class Requirement: Object {
    @objc dynamic var depth = 0
    @objc dynamic var index = ""
    @objc dynamic var text = ""
    @objc dynamic var isComplete = false
    @objc dynamic var parentRank: Rank? = nil
    @objc dynamic var parentMeritBadge: MeritBadge? = nil
}

class Rank: Object, Badge {
    @objc dynamic var name = ""
    @objc dynamic var isComplete = false
    var requirements = List<Requirement>()
}

class MeritBadge: Object, Badge {
    @objc dynamic var name = ""
    @objc dynamic var favoriteIndex = -1
    @objc dynamic var isComplete = false
    @objc dynamic var isEagle = false
    var requirements = List<Requirement>()
}
