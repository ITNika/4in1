//
//  AppDelegate.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //if no data in the CoreData, add the level data. dummy data for now.
        var bool: Bool = false
        let entity : String = "Level"
        let request = NSFetchRequest(entityName: entity)
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(request, error: &error)
        if count == 0 {
            bool = true
        }
        
        if bool{
            //set up tutorials
            let entityDescriptionForTutorials = NSEntityDescription.entityForName("Level", inManagedObjectContext: self.managedObjectContext)
            let tut1 = NSManagedObject(entity: entityDescriptionForTutorials!, insertIntoManagedObjectContext: self.managedObjectContext)
            let tut2 = NSManagedObject(entity: entityDescriptionForTutorials!, insertIntoManagedObjectContext: self.managedObjectContext)
            let tut3 = NSManagedObject(entity: entityDescriptionForTutorials!, insertIntoManagedObjectContext: self.managedObjectContext)
            let tut4 = NSManagedObject(entity: entityDescriptionForTutorials!, insertIntoManagedObjectContext: self.managedObjectContext)
            
            tut1.setValue(0, forKey: "levelNumber")
            tut1.setValue(true, forKey: "isPlayable")
            tut1.setValue(1, forKey: "numberOfPlayers")
            
            tut2.setValue(1, forKey: "levelNumber")
            tut2.setValue(true, forKey: "isPlayable")
            tut2.setValue(1, forKey: "numberOfPlayers")
            
            tut3.setValue(2, forKey: "levelNumber")
            tut3.setValue(true, forKey: "isPlayable")
            tut3.setValue(1, forKey: "numberOfPlayers")
            
            tut4.setValue(3, forKey: "levelNumber")
            tut4.setValue(true, forKey: "isPlayable")
            tut4.setValue(1, forKey: "numberOfPlayers")
            
            
            //set up levels for 2 players
            let entityDescriptionForLevels = NSEntityDescription.entityForName("Level", inManagedObjectContext: self.managedObjectContext)
            let level21 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level22 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level23 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level24 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            
            level21.setValue(0, forKey: "levelNumber")
            level21.setValue(true, forKey: "isPlayable")
            level21.setValue(2, forKey: "numberOfPlayers")
            
            level22.setValue(1, forKey: "levelNumber")
            level22.setValue(true, forKey: "isPlayable")
            level22.setValue(2, forKey: "numberOfPlayers")
            
            level23.setValue(2, forKey: "levelNumber")
            level23.setValue(false, forKey: "isPlayable")
            level23.setValue(2, forKey: "numberOfPlayers")
            
            level24.setValue(3, forKey: "levelNumber")
            level24.setValue(false, forKey: "isPlayable")
            level24.setValue(2, forKey: "numberOfPlayers")
            
            //set up levels for 3 players
            let level31 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level32 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level33 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level34 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            
            level31.setValue(0, forKey: "levelNumber")
            level31.setValue(false, forKey: "isPlayable")
            level31.setValue(3, forKey: "numberOfPlayers")
            
            level32.setValue(1, forKey: "levelNumber")
            level32.setValue(false, forKey: "isPlayable")
            level32.setValue(3, forKey: "numberOfPlayers")
            
            level33.setValue(2, forKey: "levelNumber")
            level33.setValue(false, forKey: "isPlayable")
            level33.setValue(3, forKey: "numberOfPlayers")
            
            level34.setValue(3, forKey: "levelNumber")
            level34.setValue(false, forKey: "isPlayable")
            level34.setValue(3, forKey: "numberOfPlayers")
            
            //set up levels for 4 players
            let level41 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level42 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level43 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            let level44 = NSManagedObject(entity: entityDescriptionForLevels!, insertIntoManagedObjectContext: self.managedObjectContext)
            
            level41.setValue(0, forKey: "levelNumber")
            level41.setValue(true, forKey: "isPlayable")
            level41.setValue(4, forKey: "numberOfPlayers")
            
            level42.setValue(1, forKey: "levelNumber")
            level42.setValue(true, forKey: "isPlayable")
            level42.setValue(4, forKey: "numberOfPlayers")
            
            level43.setValue(2, forKey: "levelNumber")
            level43.setValue(false, forKey: "isPlayable")
            level43.setValue(4, forKey: "numberOfPlayers")
            
            level44.setValue(3, forKey: "levelNumber")
            level44.setValue(false, forKey: "isPlayable")
            level44.setValue(4, forKey: "numberOfPlayers")
            
            
            do {
                try tut1.managedObjectContext?.save()
                try tut2.managedObjectContext?.save()
                try tut3.managedObjectContext?.save()
                try tut4.managedObjectContext?.save()
                
                try level21.managedObjectContext?.save()
                try level22.managedObjectContext?.save()
                try level23.managedObjectContext?.save()
                try level24.managedObjectContext?.save()
                
                try level31.managedObjectContext?.save()
                try level32.managedObjectContext?.save()
                try level33.managedObjectContext?.save()
                try level34.managedObjectContext?.save()
                
                try level41.managedObjectContext?.save()
                try level42.managedObjectContext?.save()
                try level43.managedObjectContext?.save()
                try level44.managedObjectContext?.save()
                
            } catch{
                print(error)
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "duedhuid.ijm" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("4-in-1.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
}
