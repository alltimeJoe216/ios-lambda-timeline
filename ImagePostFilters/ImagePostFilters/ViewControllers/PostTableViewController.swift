//
//  PostTableViewController.swift
//  ImagePostFilters
//
//  Created by Joe Veverka on 7/9/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit
import CoreData


class PostTableViewController: UITableViewController {
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Image> = {
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: "date",
            cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    var photosArray: [Image] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        cell.filteredImage = fetchedResultsController.object(at: indexPath)
        photosArray.append(fetchedResultsController.object(at: indexPath))
        print(photosArray.count)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorie = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(calorie)
            do {
                try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            } catch {
                CoreDataStack.shared.mainContext.reset()
                print("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterImageSegue" {
            guard let detailVC = segue.destination as? ImageFilterViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.photo =  fetchedResultsController.object(at: indexPath)
        } else if segue.identifier == "MapViewSegue" {
            guard let mapVC = segue.destination as? MapViewController else { return }
            mapVC.photos = self.photosArray
            for photo in self.photosArray {
                print("\(photo.latitude) , \(photo.longitude)")
            }
        }
    }
}

extension PostTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}


