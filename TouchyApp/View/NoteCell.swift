//
//  NoteCell.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-09-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var lockImgView: UIImageView!
    
    func configureCell(note: NoteTxt){
        if note.isLocked   == true {
                messageLbl.text = "This note is locked. Unlock to read."
               lockImgView.isHidden = false
            } else {
                messageLbl.text = note.text
                lockImgView.isHidden = true
            }
        }
    
    
    }

