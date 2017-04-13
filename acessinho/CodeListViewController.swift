//
//  CodeListViewController.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit
import QRCodeReaderViewController
import Firebase

class CodeListViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "yyyy/MM/dd - HH:mm:ss"
        return dateFormatter
    }()
    
    var eventId: String?
    var codes: [Code] = []
    var codesRef: FIRDatabaseReference?
    var lastCode = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        let ref = FIRDatabase.database().reference(withPath: "codes")
        codesRef = ref.child(eventId!)

        codesRef?.queryOrderedByKey().observe(.value, with: { snapshot in
            
            var newItems: [Code] = []
            
            for item in snapshot.children {
                let event = Code(snapshot: item as! FIRDataSnapshot)
                newItems.append(event)
            }
            
            self.codes = newItems
            self.tableView.reloadData()
        })
    }
    
    func addTicket(with ticketKey: String) {
        let code = Code(readTime: "", readUser: "", key: ticketKey)
        let codeItemRef = self.codesRef?.child(ticketKey)
        codeItemRef!.setValue(code.toAnyObject())
    }
    
    func removeTicket(ticket: Code) {
        ticket.ref?.removeValue()
    }
    
    func updateReadDate(ticket: Code) {
        
        if let email = FIRAuth.auth()?.currentUser?.email {
            let now = Date()
            let nowString = self.dateFormatter.string(from: now)
            ticket.ref?.updateChildValues(
                [
                    "read-date": nowString,
                    "read-user": email
                ]
            )
        }
    }
    
    //MARK: Settings
    
    @IBAction func readCodes(_ sender: Any) {
        let reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])

        let vc = QRCodeReaderViewController.reader(withCancelButtonTitle: "Cancelar",
                                                   codeReader: reader,
                                                   startScanningAtLoad: true,
                                                   showSwitchCameraButton: false,
                                                   showTorchButton: true)

        vc.modalPresentationStyle = .formSheet
        vc.delegate = self

        reader.setCompletionWith { (result) in
            if let result = result {
                if result != self.lastCode {
                    if self.codes.contains(where: { (code) -> Bool in code.key == result }) {
                        
                        let code = self.codes.filter({ (code) -> Bool in code.key == result }).first
                        
                        if code?.readTime == "" {
                            print("Authorized")
                            self.updateReadDate(ticket: code!)
                        } else {
                            print("Ticket already validated")
                        }
                        
                    } else {
                        print("Not authorized")
                    }
                }
                
                self.lastCode = result
            }
        }

        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addCode(_ sender: Any) {
        let alert = UIAlertController(title: "Ingresso",
                                      message: "Adicionar um código",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Adicionar",
                                       style: .default) { action in
                                        let ticketKey = alert.textFields![0].text
                                        self.addTicket(with: ticketKey!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension CodeListViewController: QRCodeReaderDelegate {
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.dismiss(animated: true, completion: nil)
    }
}

extension CodeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let code = codes[indexPath.row]
            self.removeTicket(ticket: code)
        }
    }
}

extension CodeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let code = codes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeTableViewCell", for: indexPath) as? CodeTableViewCell
        
        cell?.populate(with: code)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }
}
