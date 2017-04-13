//
//  CodeTableViewCell.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit

class CodeTableViewCell: UITableViewCell {

    @IBOutlet weak var codeNumber: UILabel!
    @IBOutlet weak var readDate: UILabel!
    
    func populate(with code: Code) {
        codeNumber.text = code.key
        readDate.text = code.readTime
    }
}
