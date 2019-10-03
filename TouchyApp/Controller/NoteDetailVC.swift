//
//  NoteDetailVC.swift
//  touchfeelygoodness
//
//  Created by Caleb Stultz on 9/28/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {

  
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: NoteTxt!
//    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note.text
        self.noteTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(NoteDetailVC.back(sender:)))
             self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        NoteCore.instance.changeNote(forNote: note, changedText: noteTextView.text, changeStatus: false) { (success) in
            if success {
              navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    

    

    @IBAction func lockNoteBtnWasPressed(_ sender: Any) {
        
        NoteCore.instance.changeNote(forNote: note, changedText: noteTextView.text!, changeStatus: true) { (success) in
            if success {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
