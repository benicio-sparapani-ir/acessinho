//
//  EventTableViewCell.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit
import AlamofireImage

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.af_cancelImageRequest()
        eventImageView.image = nil
    }

    func populate(with event: Event) {
        if let url = URL(string: event.imageUrl) {
            eventImageView.af_setImage(withURL: url)
        }
        
        eventName.text = event.name
    }
}
