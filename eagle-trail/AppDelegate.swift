import os.log
import RealmSwift
import SwiftyJSON
import UIKit

// Force all data to clear at app launch for debugging
let force = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Properties
    
    lazy private var realm: Realm = {
        guard let realm = try? Realm() else {
            fatalError("Error initializing realm")
        }
        return realm
    }()
    
    lazy private var preload: JSON? = {
        if !force && UserDefaults.standard.object(forKey: "initialDataLoaded") != nil {
            os_log("Reading previous data")
            return nil
        }
        
        if force {
            os_log("Forcing preload data. Deleting all objects", type: .debug)
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        UserDefaults.standard.set(true, forKey: "initialDataLoaded")
        
        guard let path = Bundle.main.path(forResource: "preload", ofType: "json") else {
            fatalError("Unable to find preload file")
        }
        
        return JSON(parseJSON: try! String(contentsOfFile: path, encoding: .utf8))
    }()
    
    // MARK: - View Hierarchy
    
    lazy private var rootViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let viewControllers = [
            RanksTableViewController(realm: realm, preload: preload),
            MeritBadgesTableViewController(realm: realm, preload: preload)
        ]
        
        tabBarController.viewControllers = viewControllers.map {
            let navigationController = UINavigationController(rootViewController: $0)
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
        
        return tabBarController
    }()
    
    var window: UIWindow?
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    
}

