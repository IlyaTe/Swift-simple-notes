//
//  TableViewController.swift
//  Notes
//
//  Created by Илья on 08.02.2020.
//  Copyright © 2020 Ilya. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var notes: [Note] = [] {
        willSet {
            sortedNotes = newValue.sorted {
                $0.date!.compare($1.date!) == .orderedDescending
            }
        }
    }
    
    var managedContext: NSManagedObjectContext!
    var sortedNotes : [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = delegate.persistentContainer.viewContext
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NoteTableViewCell
        
//        let sortedNotes = notes.sorted {
//            $0.date!.compare($1.date!) == .orderedDescending
//        }
        let note = sortedNotes[indexPath.row]
        
        cell.textNode?.text = note.textNode
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.date?.text = formatter.string(from: note.date!)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let editVC = segue.destination as! AddViewController
            
            let indexPath = tableView.indexPath(for: sender as! NoteTableViewCell)
            editVC.note = sortedNotes[indexPath!.row]
//            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
//            fetchRequest.predicate = NSPredicate(format: "id == %@", sortedNotes[indexPath.row].id!.uuidString)
//
//            do {
//                let note  = try managedContext.fetch(fetchRequest)
//                editVC.note = note[0]
//                editVC.textNote.text = sortedNotes[indexPath.row].textNode
//            } catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
        }
    }

    @IBAction func unwindToNotes(segue:UIStoryboardSegue) {
        if let vc = segue.source as? AddViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                sortedNotes[selectedIndexPath.row].title = vc.note.title
                sortedNotes[selectedIndexPath.row].textNode = vc.note.textNode
                sortedNotes[selectedIndexPath.row].date = vc.note.date
                
                save()
            } else {
                let note = vc.note!
                notes.append(note)
                
                save()
            }
        }
    }
}

extension TableViewController {
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Error: \(error), userInfo \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func fetch() {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
