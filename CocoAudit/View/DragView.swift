//
//  DragView.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/11/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Cocoa

//protocol DragDropViewDelegate
//{
//    func draggedMediaType(type: MediaType, url: NSURL)
//}

class DragView: NSView {
    
    // MARK: - Properties
    private var isFileTypeIsOk = false
    
    fileprivate var isHighlighted = false
    
    private var acceptedFileExtensions = ["lock"]
    
    //var delegate: DragDropViewDelegate?
    
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
    }
    
    // MARK: - Methods
    
    // Can draw custom shapes in view. NOTE: Must call self.setNeedsDisplay method when redrawing in within view
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
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
        return true
    }
}

extension DragView {
    // Helper Method
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension.lowercased() else {
            print("wrong extension")
            return false
        }
        print("checking if extension is acceptable")
        print("File extension", fileExtension)
        let isAcceptable = acceptedFileExtensions.contains(fileExtension)
        print("Bool is", isAcceptable)
        return isAcceptable
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
