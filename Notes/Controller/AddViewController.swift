//
//  AddViewController.swift
//  Notes
//
//  Created by Илья on 09.02.2020.
//  Copyright © 2020 Ilya. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var textNote: UITextView!
    var note: Note!
    var isEdit: Bool!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = delegate.persistentContainer.viewContext
        }
        
        if let note = note {
            isEdit = true
            textNote.text = note.textNode
        } else {
            isEdit = false
            textNote.text = ""
        }
        
        textNote.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !isEdit {
            note = Note(context: managedContext)
        }
        
        note.textNode = textNote.text
        note.title = textNote.text
        note.date = Date()
    }
}
