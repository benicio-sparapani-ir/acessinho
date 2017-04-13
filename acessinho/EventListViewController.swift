//
//  EventListViewController.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit
import Firebase

class EventListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Eventos"

        let ref = FIRDatabase.database().reference(withPath: "events")
        
        ref.observe(.value, with: { snapshot in
        
            var newItems: [Event] = []
            
            for item in snapshot.children {
                let event = Event(snapshot: item as! FIRDataSnapshot)
                newItems.append(event)
            }
            
            self.events = newItems
            self.tableView.reloadData()
        })
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

extension EventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        print(event.key)
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell
        
        cell?.populate(with: event)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
}
