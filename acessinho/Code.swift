//
//  Code.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import Foundation
import Firebase

struct Code {
    
    let key: String
    let readTime: String
    let ref: FIRDatabaseReference?
    
    init(readTime: String, key: String = "") {
        self.key = key
        self.readTime = readTime
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        readTime = snapshotValue["read-date"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "read-date": readTime
        ]
    }
}
