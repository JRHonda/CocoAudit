//
//  MainViewController.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var dropAreaImage: NSImageView!
    @IBOutlet weak var dragView: DragView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
}

extension MainViewController: NSDraggingDestination {
    
}
