//
//  MainViewController.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mainSplitView: NSSplitView!
    @IBOutlet weak var dropPodfileArea: DragView!
    @IBOutlet weak var cveSearchTextField: NSTextField!
    @IBOutlet weak var cveSearchButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var dragInstructionLabel: NSTextField!
    
    var fileUrl: URL? {
        didSet {
            // run search
        }
    }
    
    //
    var cveSearchResults: CVESearchResults?
    var podTitles: [PodTitle] = []
    var results: [CVEMatch] = []
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        mainSplitView.delegate = self
        mainSplitView.setPosition(225, ofDividerAt: 0)
        
        dropPodfileArea.delegate = self
        cveSearchResults?.delegate = self as! CVESearchDelegate
        
        
    }
    
    @IBAction func resetToInitialState(_ sender: NSButton) {
        dropPodfileArea.reset()
    }
    
    
}

extension MainViewController: NSSplitViewDelegate {
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 250
    }
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 200
    }
}

extension MainViewController: DragDropViewDelegate {
    
    func draggedFile(url: URL) -> URL? {
        fileUrl = url
        guard fileUrl != nil else {
            return nil
        }
        return fileUrl
    }
    
}
