//
//  DataStore.swift
//  Cars7peaks
//
//
//  Created by Roche on 19/05/21.
//
//

import Foundation
import CoreData

protocol UIUpdaterProtocol: class {
    
    func updateUI()
}
class DataStore: NSObject {
    

    let networkManager:NetworkManagerProtocol!
    let coreDataManager = CoreDataManager.shared()
    private weak var uiUpdater:UIUpdaterProtocol!
        
    // Initialize a fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CarItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: #keyPath(CarItem.title), cacheName: nil)
        return frc
    }()
    
    init(with netWorkManager:NetworkManagerProtocol = NetworkDataManager.shared(), uiUpdater: UIUpdaterProtocol){
        self.networkManager = netWorkManager
        self.uiUpdater = uiUpdater
        super.init()
    }
    
    // fetch The data
    func fetchCarData(){
        
        networkManager.fetchDataWith {[weak self] (result) in
            
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do{
                    let jsonDict = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    let bodydata = jsonDict?.object(forKey: "content")
                    let parsedata = try? JSONSerialization.data(withJSONObject: bodydata!)
                    let json = try decoder.decode([Cars].self, from: parsedata!)
                    self?.coreDataManager.prepare(dataForSaving: json)
                    self?.uiUpdater?.updateUI()
                }catch(let ex){
                    print(ex.localizedDescription)
                }
            case .error(let error):
                print(error.debugDescription)
            }
        }
    }
    
    func getDataFromDB(){
        
        do{
            try fetchedResultsController.performFetch()
        }catch(let ex){
            
            print(ex.localizedDescription)
        }
        
    }
}
extension DataStore: DataStoreProtocol{
    
    
    func sectionCount() ->Int{
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    func rowsCount(for section:Int) -> Int{
        
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    func itemAt(indexPath: IndexPath) -> CarsViewModel?{
        
        guard let albumItem = self.fetchedResultsController.object(at: indexPath) as? CarItem else{
            return nil
        }
        
        return createAlbumViewModelWith(albumItem: albumItem)
    }
    
    func titleForHeaderAt(section: Int) -> String{
        
        guard let sectionInfo = self.fetchedResultsController.sections?[section] else { return "" }
        return sectionInfo.name
    }
    
    private func createAlbumViewModelWith(albumItem: CarItem) -> CarsViewModel{
    
        return CarsViewModel(with: albumItem)
    }
    
    
}
