//
//  NoteObjects.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-09-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import CoreData

let appDelagate = UIApplication.shared.delegate as? AppDelegate

var note1 = Note(message: "Hello world", lockStatus: .locked)
var note2 = Note(message: "God day!", lockStatus: .unlocked)
var note3 = Note(message: "HEJ HEJ!", lockStatus: .locked)

var notesArray: [Note] = [note1, note2, note3]


class NoteCore {
    
    static let instance = NoteCore()
    
    func fetchNote(completion: (_ complete: Bool, _ noteTxt: [NoteTxt]?)-> ()){
        guard let managedContext = appDelagate?.persistentContainer.viewContext else { return }
        
        let fecthRequest = NSFetchRequest<NoteTxt>(entityName: "NoteTxt")
        var notes = [NoteTxt]()
        
        do {
           notes = try managedContext.fetch(fecthRequest)
            completion(true, notes)
        } catch  {
            debugPrint("Fetch error: \(error.localizedDescription)")
            completion(false, nil)
        }
    }
    
    func createNote(noteTxt: String, lockStatus: LockStatus, completion: (_ complete: Bool)->()) {
        
        guard let managedContext = appDelagate?.persistentContainer.viewContext else { return }
        
        let note = NoteTxt(context: managedContext)
        
        note.text = noteTxt
        
        if lockStatus == .locked {
            note.isLocked = true
        } else {
            note.isLocked = false
        }
        
        do {
            try managedContext.save()
            print("Succesfuly saved!")
            completion(true)
        } catch  {
            debugPrint("Erorr while save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func changeNote(forNote note: NoteTxt, changedText: String?, changeStatus: Bool, completion: (_ completion: Bool)->()) {
        guard let managedContext = appDelagate?.persistentContainer.viewContext else { return }
        
        let note = note
        if changedText != nil {
            note.text = changedText
        }
        
        if changeStatus == true {
            note.isLocked = lockStatusFlipper(note.isLocked)
        }
        
        do {
            try managedContext.save()
            print("Successfuly save unlock status ")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }   
    }
    
    func changeAllNoteStarusToLock(forNotes notes: [NoteTxt]) {
        
       guard let managedContext = appDelagate?.persistentContainer.viewContext else { return }
        
        for note in notes {
            if note.isLocked == false{
                note.isLocked = true
                          
                          do {
                              try managedContext.save()
                              print("Successfuly save unlock status ")
                              
                          } catch {
                              debugPrint("Could not save: \(error.localizedDescription)")
                              
                          }
            }
          
        }
        
    }
    
    func removeNote(note: NoteTxt) {
        guard let managedContext = appDelagate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(note)
        
        do{
            try managedContext.save()
            print("Successfuly removed notes!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
}
