import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - View Hierarchy
    
    var window: UIWindow?
    
    lazy private var rootViewController: UITabBarController = { [unowned self] in
        let tabBarController = UITabBarController()
        
        let viewControllers = [
            RankTableViewController(),
            MeritBadgeTableViewController()
        ]
        
        tabBarController.viewControllers = viewControllers.map {
            let navigationController = UINavigationController(rootViewController: $0)
            return navigationController
        }
        
        return tabBarController
    }()
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        loadData()
        
        window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Private Methods
    
    private func loadData(force: Bool = false) {
        
        if !force, let _ = UserDefaults.standard.object(forKey: "initialDataLoaded") {
            return
        }
        
        CoreDataManager.shared.deleteAllEntities()
        print("Fetching preload data")
        UserDefaults.standard.set(true, forKey: "initialDataLoaded")
        
        guard let path = Bundle.main.path(forResource: "preload", ofType: "json") else {
            print("Unable to find preload file")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : AnyObject] else {
                return
            }
            
            if let ranksJSON = jsonResult["ranks"] as? [AnyObject] {
                for rank in ranksJSON {
                    guard let rank = rank as? [String : AnyObject] else { continue }
                    let _: Rank? = CoreDataManager.shared.save(keyValues: [
                        "name": (rank["name"] as! CFString) as String
                    ])
                }
            }
            
            if let meritBadgesJSON = jsonResult["meritBadges"] as? [AnyObject] {
                for meritBadge in meritBadgesJSON {
                    guard let meritBadge = meritBadge as? [String : AnyObject] else { continue }
                    let _: MeritBadge? = CoreDataManager.shared.save(keyValues: [
                        "isEagle": (meritBadge["isEagle"] as! CFBoolean) as! Bool,
                        "name": (meritBadge["name"] as! CFString) as String
                    ])
                }
            }
        } catch {
            print("Unable to get contents of file")
        }
    }
    
}

