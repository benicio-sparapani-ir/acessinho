//
//  Event.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import Foundation
import Firebase

struct Event {
    
    let key: String
    let name: String
    let imageUrl: String
    let ref: FIRDatabaseReference?
    
    init(name: String, imageUrl: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.imageUrl = imageUrl
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        imageUrl = snapshotValue["image-url"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "image-url": imageUrl
        ]
    }
    
}
