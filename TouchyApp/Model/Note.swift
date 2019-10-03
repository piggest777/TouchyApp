//
//  Note.swift
//  TouchyApp
//
//  Created by Denis Rakitin on 2019-09-30.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation



class Note {
    public private(set) var message: String
    public var lockStatus: LockStatus
    
    init (message: String, lockStatus: LockStatus) {
        self.message = message
        self.lockStatus = lockStatus
    }
}
