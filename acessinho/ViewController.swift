//
//  ViewController.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit
import QRCodeReaderViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        
        let vc = QRCodeReaderViewController.reader(withCancelButtonTitle: "Cancel",
                                                   codeReader: reader,
                                                   startScanningAtLoad: true,
                                                   showSwitchCameraButton: false,
                                                   showTorchButton: true)
        
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        
        reader.setCompletionWith { (result) in
            if let result = result {
                print(result)
            }
        }
        
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: QRCodeReaderDelegate {
    func reader(_ reader: QRCodeReaderViewController!, didScanResult result: String!) {
        print(result)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController!) {
        reader.dismiss(animated: true, completion: nil)
    }
}
