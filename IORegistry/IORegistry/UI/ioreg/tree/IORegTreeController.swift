//
//  IOReg.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation
import AppKit

class IORegTreeController : NSViewController {
    static let SelectNode : Notification.Name = Notification.Name("SelectNode")
    
    let scrollView = NSScrollView()
    let outlineView = NSOutlineView()
    let treeController = NSTreeController()
    @objc dynamic var contents : [AnyObject] = []
    var keyValueObservations : [NSKeyValueObservation] = []
    
    override func loadView() {
        let view = NSView()
        view.frame = NSRect(x: 0, y: 0, width: 100, height: 600)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        treeController.childrenKeyPath = "children"
        treeController.leafKeyPath = "leaf"
        treeController.countKeyPath = "count"
        treeController.objectClass = IONode.self
        treeController.bind(NSBindingName("contentArray"), to: self, withKeyPath: "contents", options: nil)
        outlineView.bind(NSBindingName("content"), to: treeController, withKeyPath: "arrangedObjects", options: nil)
        outlineView.bind(NSBindingName("selectionIndexPaths"), to: treeController, withKeyPath: "selectionIndexPaths", options: nil)
        outlineView.autosaveExpandedItems = true
        loadData()
        treeController.selectsInsertedObjects = true
        keyValueObservations.append(treeController.observe(\.selectedObjects, options: [.new]) {(treeController, change) in
            NotificationCenter.default.post(name: IORegTreeController.SelectNode, object: treeController, userInfo: nil)
            self.invalidateRestorableState()
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {[weak self] in
            guard let self = self else { return }
            let index = IndexPath(index: 0)
            self.treeController.setSelectionIndexPath(index)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    deinit {
        for obs in keyValueObservations {
            obs.invalidate()
        }
        keyValueObservations.removeAll()
    }
}

extension IORegTreeController {
    private func createUI() {
        scrollView.documentView = outlineView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(300).priority(100)
        }
        outlineView.delegate = self
        outlineView.usesAlternatingRowBackgroundColors = true
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        column.title = ""
        outlineView.addTableColumn(column)
    }
    
    func loadDataToContent(node:IONode) -> IONode {
        let children = OCUtil.children(node.entry, plane: kIOServicePlane)
        for childEntry in children {
            var child = IONode()
            child.entry = io_registry_entry_t(truncating: childEntry)
            child = loadDataToContent(node: child)
            node.children.append(child)
        }
        node.updateLeaf()
        return node
    }
    
    private func loadData() {
        let root = IORegistryGetRootEntry(kIOMasterPortDefault)
        var node = IONode()
        node.entry = root
        node = loadDataToContent(node: node)
        self.contents.removeAll()
        self.contents.append(node)
        outlineView.expandItem(node)
    }
}

extension IORegTreeController {
    class func node(from item: Any) -> IONode? {
        if let treeNode = item as? NSTreeNode, let node = treeNode.representedObject as? IONode {
            return node
        } else {
            return nil
        }
    }
}

extension IORegTreeController : NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        let row = outlineView.row(forItem: item)
        var rowView = outlineView.rowView(atRow: row, makeIfNecessary: false) as! IORelationRowView?
        if rowView == nil {
            rowView = IORelationRowView()
            rowView?.outlineView = outlineView
        }
        rowView?.item = item as? NSTreeNode
        return rowView
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        outlineView.enumerateAvailableRowViews { (rowView, index) in
            rowView.setNeedsDisplay(rowView.bounds)
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = Self.node(from: item) else {
            return nil
        }
        var view : IORegCell
        if let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("node"), owner: nil) as? IORegCell {
            view = cell
        }else{
            view = IORegCell()
            view.identifier = NSUserInterfaceItemIdentifier("node")
        }
        view.text = item.name
        return view
    }
}
