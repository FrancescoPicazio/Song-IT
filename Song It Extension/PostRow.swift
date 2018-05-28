//
//  PostRow.swift
//  Song-IT
//
//  Created by Francesco Picazio on 17/01/18.
//  Copyright © 2018 Giovanni Bassolino. All rights reserved.
//

import WatchKit

class PostRow: NSObject {
    @IBOutlet var songTitle: WKInterfaceLabel!
    @IBOutlet var artistName: WKInterfaceLabel!
    
    @IBOutlet var nlike: WKInterfaceLabel!
    @IBOutlet var ndislike: WKInterfaceLabel!
    
    @IBOutlet var backgorund: WKInterfaceGroup!
}
