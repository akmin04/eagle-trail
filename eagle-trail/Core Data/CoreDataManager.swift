import CoreData

class CoreDataManager {
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EagleTrail")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Operations
    
    func fetch<T : NSManagedObject>(filter: ((T) -> Bool)? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
        
        do {
            var fetched = try persistentContainer.viewContext.fetch(fetchRequest)
            if let filter = filter {
                fetched = fetched.filter(filter)
            }
            
            return fetched
        } catch let error as NSError {
            print("Core Data Fetch - Error. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func save<T: NSManagedObject>(keyValues: [String : Any?]) -> T? {
        let description = NSEntityDescription.entity(forEntityName: "\(T.self)", in: persistentContainer.viewContext)!
        let entity = NSManagedObject(entity: description, insertInto: persistentContainer.viewContext) as! T
        
        for (key, value) in keyValues {
            entity.setValue(value, forKey: key)
        }
        
        do {
            try persistentContainer.viewContext.save()
            return entity
        } catch let error as NSError {
            print("Core Data Save - Error. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func update(entity: NSManagedObject, keyValues: [String : Any?]) {
        for (key, value) in keyValues {
            entity.setValue(value, forKey: key)
        }
        
        saveContext()
    }
    
    func delete(entity: NSManagedObject) {
        persistentContainer.viewContext.delete(entity)
        saveContext()
    }
    
    func deleteAllEntities() {
        let entities = persistentContainer.managedObjectModel.entities
        for entity in entities {
            print("Deleting Entity - ", entity.name ?? "error")
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "error")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
            } catch let error as NSError{
                print("Core Data Delete All Entries - Error. \(error), \(error.userInfo)")
            }
        }
        saveContext()
    }
}
