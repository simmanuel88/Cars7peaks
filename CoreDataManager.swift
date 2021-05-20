//
//  CoreDataManager.swift
//  Cars7peaks
//
//
//  Created by Roche on 19/05/21.


import Foundation
import CoreData
import UIKit


class CoreDataManager: NSObject{
    var image:UIImage = UIImage(named: "audi_q7")!

    private override init() {
        super.init()
        
        applicationLibraryDirectory()
    }
    // Create a shared Instance
    static let _shared = CoreDataManager()
    
    // Shared Function
    class func shared() -> CoreDataManager{
        return _shared
    }
    
    // Get the location where the core data DB is stored
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    private func applicationLibraryDirectory() {
        print(applicationDocumentsDirectory)
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    // MARK: - Core Data stack
    
    // Get the managed Object Context
    lazy var managedObjectContext = {
        
        return self.persistentContainer.viewContext
    }()
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Cars7peaks")
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
    
    func prepare(dataForSaving: [Cars]){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CarItem")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
        
        // loop through all the data received from the Web and then convert to managed object and save them
        _ = dataForSaving.map{self.createEntityFrom(car: $0)}
        saveData()
    }
    
    private func createEntityFrom(car: Cars) -> CarItem?{
        
        // Check for all values
        guard let title = car.title,let dateTime = car.dateTime,let ingress = car.ingress,let image = car.image else {
            
            return nil
        }
        
        // Convert
        let carItem = CarItem(context: self.managedObjectContext)
        carItem.title = title as NSObject
        carItem.dateTime = dateTime as NSObject
        carItem.ingress = ingress as NSObject
        carItem.image = image as NSObject
        var urlString = image as String
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let fileUrl = NSURL(string:urlString)
        carItem.thumbnail = downloadImage(from:fileUrl! as URL)
        return carItem
        
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage {

        if let data = try? Data(contentsOf: url) {
              // Create Image and Update Image View
            self.image = UIImage(data: data)!
          }
        return image

    }
    
    // Save the data in Database
    func saveData(){
        
        let context = self.managedObjectContext
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
    
    // Save Data in background
    func saveDataInBackground() {
        
        persistentContainer.performBackgroundTask { (context) in
            
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
    }
    
}

