//
//  ObservationListTableViewController.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 2.04.24.
//

import UIKit
import CoreData

class ObservationListTableViewController: UITableViewController {

    // Initialize the fetched results controller with the fetch request and
    // managed object context.
    lazy var fetchedResultsController: NSFetchedResultsController<Observation>  = {
        
        // Get the managed object context from the persistent container.
        let context = PersistenceCoordinator.sharedInstance.persistentContainer.viewContext


        // Create a fetch request and sort descriptor for the entity to display
        // in the table view.
        let fetchRequest: NSFetchRequest<Observation> = Observation.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateBegin", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: context,
        sectionNameKeyPath: nil,
        cacheName: nil)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Handle error appropriately. It's useful to use
            // `fatalError(_:file:line:)` during development.
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
                return 0
            }
            
            return sectionInfo.numberOfObjects
    }

    // Get table view cells for index paths from the fetched results controller.
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "observationCell", for: indexPath)
        
        let observation = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = observation.observationPeriodString()
        cell.detailTextLabel?.text = (observation.notes != nil) ?  "\(observation.notes?.count ?? 0)" : "Няма страници"
        
        return cell
    }


    // Get the title of the header for the specified table view section from the
    // fetched results controller.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return nil
        }
        
        return sectionInfo.name
    }

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ClickedObservation":
            guard let selectedIndex = tableView.indexPathForSelectedRow else { break }
            guard let destinationVC = segue.destination as? ShowObservationViewController else { break }
            destinationVC.observation = fetchedResultsController.object(at: selectedIndex)
            
        default:
            break
        }
    }

}
