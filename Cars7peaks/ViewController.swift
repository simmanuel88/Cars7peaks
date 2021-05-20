//
//  ViewController.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//

import UIKit
import CoreData


class ViewController: UIViewController, UIUpdaterProtocol {
  
    private var carTableView:UITableView!
    func updateUI() {
        
        self.navigationItem.title = "Cars"
        navigationController?.navigationBar.barTintColor =  UIColor(red: 80/255, green: 76/255, blue: 76/255, alpha: 1) //rgb(80,76,76)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        
        dataStore.getDataFromDB()
        carTableView.reloadData()
    }
    var dataStore:DataStore!
    var image:UIImage = UIImage(named: "audi_q7")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
        setUpTableView()

        dataStore = DataStore(uiUpdater: self)
        dataStore.fetchedResultsController.delegate = self
        fetchData()
        
        if !Reachability.isConnectedToNetwork(){
            updateUI()
        }
    }
    
    func setUpTableView() {
        
        carTableView = UITableView()
        carTableView.delegate = self
        carTableView.dataSource = self
        carTableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        carTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(carTableView)
        
        carTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        carTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        carTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        carTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Register Cell
        //dataTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        let xib : UINib = UINib (nibName: "CarTableViewCell", bundle: nil)
        carTableView.register(xib, forCellReuseIdentifier: "CarTableViewCell")
        carTableView.rowHeight = 350.0
        carTableView.estimatedRowHeight = 350.0
        
    }
    
    func fetchData(){
        
        dataStore.fetchCarData()
    }

}

extension ViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Start Update
        carTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                carTableView.insertRows(at: [indexPath], with: .middle)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                carTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            break;
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            carTableView.insertSections(IndexSet(integer: sectionIndex), with: .middle)
        case .delete:
            carTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // End update
        carTableView.endUpdates()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    

    
   
     // send 24 hrs time format to am/pm
    func dateformat(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMMM yyyy h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStore.sectionCount()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataStore.rowsCount(for: section)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell
        
        guard let car = dataStore.itemAt(indexPath: indexPath) else{
            return cell
        }
        print(car)
        cell.lblShowIngress.text = car.ingress!
        cell.lblShowTitle.text = car.title!
        cell.lblShowDate.text = dateformat(dateString: car.dateTime!)
        if car.thumbnail != nil {
            cell.imgLoadCar.image = car.thumbnail!
        }
     
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil //dataStore.titleForHeaderAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // guard let album = dataStore.itemAt(indexPath: indexPath) else{
            return
        }
      //  navigator.navigate(to: .second(album: album))
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 350.0
   }

    






