//
//  NoteVC.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-09-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData



class NoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [NoteTxt]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NoteCore.instance.fetchNote { (success, notes) in
            if success {
                self.notes = notes!
                
                tableView.reloadData()
            }
        }
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as? NoteCell else { return UITableViewCell() }
        
        let note = notes[indexPath.row]
        
        cell.configureCell(note: note)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if notes[indexPath.row].isLocked == true {
            authBiometrics { (success) in
                if success {
                    
                    let note = self.notes[indexPath.row]
                    
                    NoteCore.instance.changeNote(forNote: note, changedText: nil, changeStatus: true) { (success) in
                        if success {
                            self.pushNoteFor(indexPath: indexPath)
                        }
                    }
                }
            }
        } else {
            pushNoteFor(indexPath: indexPath)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteRow(forRowAtIndexPath: indexPath)
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        


        return config
        
        
    }
    

    
    func deleteRow(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction{
        let note = notes[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "actionTitle") { (action, view, completionHandler) in
            NoteCore.instance.removeNote(note: note)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            NoteCore.instance.fetchNote { (success, notes) in
                if success {
                    self.notes.removeAll()
                    self.notes = notes!
                    self.tableView.reloadData()
                }
            }
            }
        }
        
        action.title = "Remove"
          return action
    }
    
    @IBAction func lockAll(_ sender: Any) {
        NoteCore.instance.changeAllNoteStarusToLock(forNotes: notes)
        tableView.reloadData()
        
    }
    
    
    func pushNoteFor(indexPath: IndexPath) {
        guard let noteDetailVC = storyboard?.instantiateViewController(identifier: "NoteDetailVC") as? NoteDetailVC else {
            return
        }
        noteDetailVC.note = notes[indexPath.row]
//        noteDetailVC.index = indexPath.row
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    func authBiometrics(completion: @escaping (Bool) -> Void){
        let myContext = LAContext()
        let myLocalizedReasonString = "PUT YOU FINGER OR FACE TO DAMN PHONE"
        var authError: NSError?
        
        func showAlert(withMessage message: String){
            let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
        }
                            if #available(iOS 8.0, macOS 10.12.1, *) {
                if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
//                    DispatchQueue.main.async {
                                            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                            DispatchQueue.main.async {
                                    if success {
                                    completion(true)
                                } else {
                                    guard let evaluateErrorString = evaluateError?.localizedDescription else { return }
                                    showAlert(withMessage: evaluateErrorString)
                                    completion(false)
                                }
                            }
                        }
//                    }
                    

                    
                } else {
//                    DispatchQueue.main.async {
                                            guard let authErrorString = authError?.localizedDescription else { return }
                            showAlert(withMessage: authErrorString)
                        completion(false)
                    }

//                }
                                
                                
                                
            } else {
                completion(false)
            }
    }
}

