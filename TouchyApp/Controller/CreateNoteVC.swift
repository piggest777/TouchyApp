//
//  CreateNoteVC.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-10-01.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class CreateNoteVC: UIViewController {

    @IBOutlet weak var noteTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
//        noteTxtView.addGestureRecognizer(tap)
        
        self.noteTxtView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
//    @objc func removeKeyboard(){
//
//        noteTxtView.resignFirstResponder()
//
//    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onlySaveBtn(_ sender: Any) {
        showAction()
}

    func showAction () {
        let alertVC = UIAlertController(title: "Please choose", message: "Create and lock or just create", preferredStyle: .actionSheet)
        
        let createAndSaveAlert = UIAlertAction(title: "Create and Locked!", style: .default) { (action) in
            NoteCore.instance.createNote(noteTxt: self.noteTxtView.text, lockStatus: .locked) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        let createAlert = UIAlertAction(title: "Create ", style: .default) { (action) in
            NoteCore.instance.createNote(noteTxt: self.noteTxtView.text, lockStatus: .unlocked) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        let closeAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(createAlert)
        alertVC.addAction(createAndSaveAlert)
        alertVC.addAction(closeAlert)
        present(alertVC, animated: true, completion: nil)
    }

}

