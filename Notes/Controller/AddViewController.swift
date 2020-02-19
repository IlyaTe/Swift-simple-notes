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


    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var textNote: UITextView!
    
    var note: Note!
    var isEdit: Bool!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = delegate.persistentContainer.viewContext
        }
        
        initialValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataRecord()
        saveToCD()
    }
    
    @IBAction func done() {
        textNote.resignFirstResponder()
    }
    
    func initialValues() {
        if let note = note {
            isEdit = true
            textNote.text = note.textNode
        } else {
            isEdit = false
            textNote.becomeFirstResponder()
        }
    }
    
    func dataRecord() {
        guard textNote.text.isEmpty == false else {
            if isEdit {
                managedContext.delete(note)
                saveToCD()
            }
            return
        }
        if !isEdit {
                note = Note(context: managedContext)
        }
        
        note.textNode = textNote.text
        
        var range: Range<String.Index>
        if textNote.text.count > 100 {
            range = textNote.text.startIndex..<textNote.text.index(textNote.text.startIndex, offsetBy: 100)
        } else {
            range = textNote.text.startIndex..<textNote.text.endIndex
        }
        note.title = String(textNote.text[range])
        
        note.date = Date()
    }
    
    func saveToCD() {
        do {
            try managedContext.save()
        } catch let error as NSError {
          print("Error: \(error), userInfo \(error.userInfo)")
        }
    }
}
