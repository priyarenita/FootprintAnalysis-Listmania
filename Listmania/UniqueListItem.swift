//
//  UniqueListItem.swift
//  Listmania
//
//  Created by Renita Priya on 11/19/16.
//  Copyright © 2016 Renita Priya. All rights reserved.
//

import Foundation
import Firebase

struct UniqueListItem {
    
    let key: String
    let name: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    
    init(name: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "completed": completed
        ]
    }
    
}
