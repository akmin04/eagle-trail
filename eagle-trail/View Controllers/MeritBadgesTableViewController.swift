import os.log
import RealmSwift
import SnapKit
import SwiftyJSON
import UIKit

class MeritBadgesTableViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var realm: Realm!
    
    private var meritBadges: [MeritBadge]!
    private var favoriteMeritBadges: [MeritBadge]!
    private var eagleMeritBadges: [MeritBadge]!
    private var alphabetizedMeritBadges: [[MeritBadge]]!
    private var completedMeritBadges: [MeritBadge]!
    private var filteredMeritBadges: [MeritBadge]!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(MeritBadgeTableViewCell.self)
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var sections: [String] = {
        let sections = ["Favorites", "Eagle Required"] + (65...90).map { fromAscii($0) } + ["Completed"]
        return sections
    }()
    
    // MARK: - Init
    
    init(realm: Realm, preload: JSON?) {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Merit Badges", image: UIImage.meritBadge, tag: 1)
        
        self.realm = realm
        
        if let preload = preload {
            os_log("Loading merit badge preload", type: .info)
            
            for data in preload["meritBadges"].arrayValue {
                try! realm.write {
                    let meritBadge = MeritBadge()
                    meritBadge.isEagle = data["isEagle"].boolValue
                    meritBadge.name = data["name"].stringValue
                    
                    for data in data["requirements"].arrayValue {
                        let requirement = Requirement()
                        requirement.depth = data["depth"].intValue
                        requirement.index = data["index"].stringValue
                        requirement.text = data["text"].stringValue
                        if requirement.depth == 0 {
                            requirement.parentMeritBadge = meritBadge
                        }
                        meritBadge.requirements.append(requirement)
                    }
                    realm.add(meritBadge)
                }
            }
        }
        
        meritBadges = Array(realm.objects(MeritBadge.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Merit Badges"
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        sortMeritBadges()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortMeritBadges()
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func sortMeritBadges() {
        meritBadges.sort { $0.name < $1.name }
        
        eagleMeritBadges = meritBadges.filter { $0.isEagle }
        completedMeritBadges = meritBadges.filter { $0.isComplete }
        alphabetizedMeritBadges = Array(repeating: [MeritBadge](), count: 26)
        favoriteMeritBadges = meritBadges
            .filter { $0.favoriteIndex != -1 }
            .sorted { (b1, b2) in b1.favoriteIndex < b2.favoriteIndex}
        
        for meritBadge in meritBadges {
            alphabetizedMeritBadges[toAscii(meritBadge.name.first!) - 65].append(meritBadge)
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private func toAscii(_ char: Character) -> Int {
        return Int(UnicodeScalar(String(char))!.value)
    }
    
    private func fromAscii(_ value: Int) -> String {
        return String(Character(UnicodeScalar(value)!))
    }
    
    private func meritBadgeAt(_ indexPath: IndexPath) -> MeritBadge {
        if isFiltering() {
            return filteredMeritBadges[indexPath.row]
        }
        
        switch indexPath.section {
        case 0:
            return favoriteMeritBadges[indexPath.row]
        case 1:
            return eagleMeritBadges[indexPath.row]
        case 28:
            return completedMeritBadges[indexPath.row]
        default:
            return alphabetizedMeritBadges[indexPath.section - 2][indexPath.row]
        }
    }
    
    private func numberOfRowsIn(section: Int) -> Int {
        if isFiltering() {
            return filteredMeritBadges.count
        }
        
        switch section {
        case 0:
            return favoriteMeritBadges.count
        case 1:
            return eagleMeritBadges.count
        case 28:
            return completedMeritBadges.count
        default:
            return alphabetizedMeritBadges[section - 2].count
        }
    }
    
}

extension MeritBadgesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(RequirementsTableViewController(badge: meritBadgeAt(indexPath), realm: realm), animated: true)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.section == 0 ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension MeritBadgesTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering() ? nil : (numberOfRowsIn(section: section) > 0 ? sections[section] : nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MeritBadgeTableViewCell
        cell.setup(meritBadge: meritBadgeAt(indexPath), indexPath: indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 && !isFiltering()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = meritBadgeAt(sourceIndexPath)
        favoriteMeritBadges.remove(at: sourceIndexPath.row)
        favoriteMeritBadges.insert(movedObject, at: destinationIndexPath.row)
        
        for (i, meritBadge) in favoriteMeritBadges.enumerated() {
            try! realm.write {
                meritBadge.favoriteIndex = i
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["★", "◯"] + (65...90).map { fromAscii($0) } + ["✓"]
    }
    
}

extension MeritBadgesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredMeritBadges = meritBadges.filter {
            $0.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableView.reloadData()
    }
    
}

extension MeritBadgesTableViewController: Favoritable {
    
    func toggleFavorite(indexPath: IndexPath) {
        let meritBadge = meritBadgeAt(indexPath)
        
        try! realm.write {
            meritBadge.favoriteIndex = (meritBadge.favoriteIndex == -1) ? favoriteMeritBadges.count : -1
        }
        
        sortMeritBadges()
        tableView.reloadData()
    }
    
}
