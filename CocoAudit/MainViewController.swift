//
//  MainViewController.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa
import WebKit

class MainViewController: NSViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mainSplitView: NSSplitView!
    @IBOutlet weak var dropPodfileArea: DragView!
    @IBOutlet weak var cveSearchTextField: NSTextField!
    @IBOutlet weak var cveSearchButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var dragInstructionLabel: NSTextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var podfileResultsTableView: NSTableView!
    
    var tableViewData = ["Test", "For", "TableView"]
    var urlTableData: [URL] = []
    
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
        
        // Tableview delegate
        podfileResultsTableView.delegate = self
        podfileResultsTableView.dataSource = self
        
        // Split view setup
        mainSplitView.delegate = self
        mainSplitView.setPosition(225, ofDividerAt: 0)
        
        // UI Delegates
        cveSearchTextField.delegate = self

        
        // Model delegates
        dropPodfileArea.delegate = self
        cveSearchResults?.delegate = self as? CVESearchDelegate
        
        
    }
    @IBAction func search(_ sender: NSButton) {
        
        tableViewData.append("hello")
        podfileResultsTableView.reloadData()
    }
    
    @IBAction func resetToInitialState(_ sender: NSButton) {
        dropPodfileArea.reset()
        
    }
    
    
}

extension MainViewController: NSTableViewDelegate {
    

    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25.0
    }
}

extension MainViewController: NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        tableView.cell?.isSelectable = false
        
        
        let str = tableViewData[row]
        let url = URL(string: "https://www.google.com")
        //let attrStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.link:url])
        let attrStr = NSMutableAttributedString(string: str)
        let strCount = str.count
        
        urlTableData.append(url!)
    
        attrStr.setAttributes([.link:url!], range: NSRange(location: 0, length: strCount))
        return NSTextField(labelWithAttributedString: attrStr)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // 
        let selectedRow = podfileResultsTableView.selectedRow
        // Loads new page based on url accessed
        webView.load(URLRequest(url: urlTableData[selectedRow]))
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
            let urlString = "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=\(cveSearchTextField.stringValue)&search_type=all"
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            webView.load(urlRequest)
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
