//
//  DragView.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa

protocol DragDropViewDelegate: AnyObject
{
    var fileUrl: URL? { get set }
    func draggedFile(url: URL) -> URL?
}

class DragView: NSView {
    
    var urls: [URLRequest] = []
    
    // MARK: - Properties
    private var isFileTypeIsOk = false
    
    fileprivate var isHighlighted = false
    
    private var acceptedFileExtensions = ["lock"]
    
    var delegate: DragDropViewDelegate?
    
    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if #available(OSX 10.13, *) {
            registerForDraggedTypes(
                [NSPasteboard.PasteboardType.fileURL]
            )
        } else {
            // Fallback on earlier OS versions
            registerForDraggedTypes(
                [.fileName]
            )
        }
        //self.setNeedsDisplay(NSRect(x: 0, y: 0, width: 218, height: 218))
    }
    

    
    // MARK: - Methods
    
    // Can draw custom shapes in view. NOTE: Must call self.setNeedsDisplay method when redrawing in within view
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        super.layer?.backgroundColor = .init(gray: 0.1, alpha: 1)
        super.layer?.cornerRadius = 8
    }
    
    // Called first and when user renters drop area if they left
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("draggingEntered")
        // Highlight area
        isHighlighted = true
        // Check if file extension is permitted
        isFileTypeIsOk = checkExtension(drag: sender)
        // self.setNeedsDisplay(self.bounds) // Only need to call if draw contents with drawRect
        
        return .init()
    }
    
    // Called continuously as dragging
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("dragging Updated")
        return isFileTypeIsOk ? .copy : .init()
    }
    
    // User has exited the drop view area, mouse-down with item.
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("draggingExited")
        
        super.layer?.borderWidth = 0
        isHighlighted = false
    }
    
    // User has moused-up inside/outside of drop view area
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("draggingEnded")
    }
    
    // User is about to drop item in drop view area
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("prepareForDragOperation")
        return true
    }
    
    // Called when user lets go of dragged item in drop area
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("performDragOperation")
        guard let draggedFileUrl = sender.draggedFileURL else {
            return false
        }
        print("Dragged file URL", draggedFileUrl)
        let urlRequests = [
            URLRequest(url: URL(string: "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=Firebase&search_type=all")!),
            URLRequest(url: URL(string: "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=React&search_type=all")!),
            URLRequest(url: URL(string: "https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=Alamofire&search_type=all")!),
            
        ]
        
        urls.append(contentsOf: urlRequests)
        
        urlsToDemo.append(contentsOf: urls)
        // Set delegate property with delegate method call
        if let fileUrl = self.delegate?.draggedFile(url: draggedFileUrl) {
            self.delegate?.fileUrl = fileUrl // protocol variable must be NOT be assigned directly from delegate method call because it will throw simulataneous access errors. This is why I am using an if-let statement
        }
        
        return true
    }
}

// MARK: - Helper Methods
extension DragView {
    // Helper Methods
    
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension.lowercased() else {
            print("wrong extension")
            
            return false
        }
        
        print("checking if extension is acceptable")
        print("File extension", fileExtension)
        let isAcceptable = acceptedFileExtensions.contains(fileExtension)
        print("Bool is", isAcceptable)
        
        if isAcceptable {
            self.drawBorder(withColor: .green)
        } else {
            self.drawBorder(withColor: .red)
        }
        
        
        return isAcceptable
    }
    
    fileprivate func drawBorder(withColor color: NSColor) {
        super.layer?.borderColor = color.cgColor
        super.layer?.borderWidth = 4
    }
    
    /// Draws border with dashes or no dashes if set the dash length to 0
    func drawBorderWith(dashHeight: CGFloat, dashLength: CGFloat, color: NSColor) {
        // setup the context
        let currentContext = NSGraphicsContext.current!.cgContext
        currentContext.setLineWidth(dashHeight)
        currentContext.setLineCap(.round)
        currentContext.setLineDash(phase: 0, lengths: [dashLength])
        currentContext.setStrokeColor(color.cgColor)

        // draw the dashed path
        currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
        currentContext.strokePath()
    }
    
    func reset() {
        print("Resetting view")
        super.layer?.borderWidth = 0
    }
}

extension NSDraggingInfo {
    var draggedFileURL: URL? {
        let filenames = draggingPasteboard.propertyList(forType: .fileName) as? [String]
        let path = filenames?.first
        print(filenames?.first as Any)
        return path.map { URL(fileURLWithPath: $0) }
    }
}

extension NSPasteboard.PasteboardType {
    
    /// The name of a file or directory
    static let fileName: NSPasteboard.PasteboardType = {
        return NSPasteboard.PasteboardType("NSFilenamesPboardType")
    }()
}

enum MediaType: String {
    case Lock = "lock"
}
