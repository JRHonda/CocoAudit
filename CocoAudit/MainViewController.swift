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
    @IBOutlet weak var resultsCountLabel: NSTextField!
    
    var fileUrl: URL? {
        didSet {
            // run search
        }
    }
    
    //
    var cveSearchResults: CVESearchResults?

    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        resultsCountLabel.stringValue = "" // default ""
        
        
        // Split view setup
        mainSplitView.delegate = self
        mainSplitView.setPosition(225, ofDividerAt: 0)
        
        // UI Delegates
        cveSearchTextField.delegate = self

        
        // Model delegates
        dropPodfileArea.delegate = self
        cveSearchResults?.delegate = self as? CVESearchDelegate
        
        
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

extension MainViewController: NSTextFieldDelegate {
    
    // TODO: - Can implement real-time search while user is typing with this method
    func controlTextDidChange(_ obj: Notification) {
        print("controlTextDidChange")
    }
    
    /*
     Will fire when user presses enter or tab. We allow enter only with logic below.
     */
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let movement = obj.userInfo?["NSTextMovement"] as? Int else { return }
        
        if movement == NSReturnTextMovement {
            // TODO: - Run search against database
            print("Return was pressed oh yeah!")
        } else {
            return
        }
    }
    
}

extension MainViewController: CVESearchDelegate {
    func searchRedHat() {
        
    }
    
    func parseResults(results: AnyObject) -> Any? {
        return SearchBlob(bodyResponse: nil)
    }
    
    
}
