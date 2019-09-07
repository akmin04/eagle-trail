import RealmSwift

class Requirement: Object {
    @objc dynamic var depth = 0
    @objc dynamic var index = ""
    @objc dynamic var text = ""
    @objc dynamic var isComplete = false
    @objc dynamic var parentRank: Rank? = nil
    @objc dynamic var parentMeritBadge: MeritBadge? = nil
}

class Rank: Object {
    @objc dynamic var name = ""
    @objc dynamic var isComplete = false
    let requirements = List<Requirement>()
}

class MeritBadge: Object {
    @objc dynamic var name = ""
    @objc dynamic var favoriteIndex = -1
    @objc dynamic var isComplete = false
    @objc dynamic var isEagle = false
    let requirements = List<Requirement>()
}
