//
//  MainViewController.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa
import WebKit

public var urlsToDemo: [URLRequest] = []

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
    
    var tableViewData = ["Firebase", "React", "Alamofire"]
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
        //mainSplitView.setPosition(250, ofDividerAt: 0)
        
        // UI Delegates
        cveSearchTextField.delegate = self

        
        // Model delegates
        dropPodfileArea.delegate = self
        cveSearchResults?.delegate = self
        
        
    }
    
    @IBAction func search(_ sender: NSButton) {
        //tableViewData.append(cveSearchTextField.stringValue)
        podfileResultsTableView.reloadData()
        let urlString = "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=\(cveSearchTextField.stringValue)&search_type=all"
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        DispatchQueue.main.async {
            self.webView.load(urlRequest)
        }
        
    }
    
    @IBAction func resetToInitialState(_ sender: NSButton) {
        dropPodfileArea.reset()
        urlsToDemo.removeAll()
        podfileResultsTableView.reloadData()
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
//        let urlString = "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=\(str)&search_type=all"
//        let url = URL(string: urlString)
        
        //let attrStr = NSAttributedString(string: str, attributes: [NSAttributedString.Key.link:url])
        let attrStr = NSMutableAttributedString(string: str)
        let strCount = str.count
        
       // urlTableData.append(url!)
        if urlsToDemo.count == 0 {
            return nil
        }
    
        attrStr.setAttributes([.link:urlsToDemo[row]], range: NSRange(location: 0, length: strCount))
        return NSTextField(labelWithAttributedString: attrStr)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // Adding a comment
        let selectedRow = podfileResultsTableView.selectedRow
        // Loads new page based on url accessed
       // webView.load(URLRequest(url: urlTableData[selectedRow]))
        webView.load(urlsToDemo[selectedRow])
    }

}

extension MainViewController: NSSplitViewDelegate {
//    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//        return 400
//    }
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 250
    }
}

extension MainViewController: DragDropViewDelegate {
    
    func draggedFile(url: URL) -> URL? {
        fileUrl = url
        guard fileUrl != nil else {
            return nil
        }
        podfileResultsTableView.reloadData()
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
