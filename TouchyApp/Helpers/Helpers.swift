//
//  Helpers.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-10-01.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import UIKit

func isNoteLocked (_ lockStatus: LockStatus) -> Bool {
    if lockStatus == .locked {
        return true
    } else {
        return false
    }
}

func lockStatusFlipper(_ lockStatus: Bool) -> Bool {
    if lockStatus == true {
        return false
    } else {
        return true
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
