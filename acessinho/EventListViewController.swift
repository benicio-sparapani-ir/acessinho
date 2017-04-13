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
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "SignInSignUpViewController", sender: nil)
        } catch (let error) {
            print(error)
        }
    }
    
    //MARK: Settings
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = sender as? IndexPath
        
        if let indexPath = indexPath, segue.identifier == "CodeListViewController" {
            let event = events[indexPath.row]
            let vc = segue.destination as? CodeListViewController
            vc?.eventId = event.key
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CodeListViewController", sender: indexPath)
    }
}

extension EventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell
        
        cell?.populate(with: event)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
}
