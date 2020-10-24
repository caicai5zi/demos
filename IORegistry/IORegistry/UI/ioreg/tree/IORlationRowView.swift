//
//  IORlationRowView.swift
//  HRSword
//
//  Created by app on 2020/10/23.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation
import AppKit

class IORelationRowView : NSTableRowView {
    var item : NSTreeNode? = nil
    var outlineView : NSOutlineView? = nil
    
    static let defaultColor = NSColor.lightGray
    static let selectedColor = NSColor(named: "outlineViewLineColor")!
    
    override func drawBackground(in dirtyRect: NSRect) {
        super.drawBackground(in: dirtyRect)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let outline = outlineView,
           let item = item {
            let lev = outline.level(forItem: item)
            if lev > 0 {
                drawLines(dirtyRect)
            }
        }else{
        }
    }
    
    func drawLines(_ dirtyRect:NSRect) {
        guard let item = item ,
              let node = item.representedObject as? IONode,
              let outline = outlineView
        else {
            return
        }
        
        let width:CGFloat = 16 //level
        var xoffset:CGFloat = -5
        var leafWidth:CGFloat = 2
        if #available(macOS 11.0, *) {
            xoffset = -17
            leafWidth = 14
        }
        let height:CGFloat = dirtyRect.height
        let yoffset:CGFloat = CGFloat(Int(height/2))
        let lev = outline.level(forItem: item)
        let selectedArr = selectedArray()
        
        //横线
        if selectedArr.contains(item) {
            Self.selectedColor.setFill()
        }else{
            Self.defaultColor.setFill()
        }
        if node.leaf {
            let path = NSBezierPath()
            path.appendRect(NSRect(x: xoffset + CGFloat(lev) * width, y: yoffset, width: 12 + leafWidth, height: 2))
            path.appendOval(in: NSRect(x: xoffset + CGFloat(lev) * width + 9 + leafWidth, y: yoffset - 2, width: 6, height: 6))
            path.fill()
        }else{
            let path = NSBezierPath()
            path.appendRect(NSRect(x: xoffset + CGFloat(lev) * width, y: yoffset, width: 12, height: 2))
            path.fill()
        }
        
        //竖线
        do {
            let startNode = item
            var node = item
            var lev = outline.level(forItem: node)
            while lev > 0 {
                let parent = outline.parent(forItem: node) as! NSTreeNode
                var childIndex = -1
                if selectedArr.contains(parent),
                   let index = selectedArr.firstIndex(of: parent) ,index > 0 {
                    let selecetedItem = selectedArr[index - 1]
                    childIndex = outline.childIndex(forItem: selecetedItem)
                }
                let index = outline.childIndex(forItem: node)
                let count = parent.children?.count ?? 0
                if index < count - 1 {
                    if childIndex >= 0 && childIndex > index {
                        Self.selectedColor.setFill()
                    }else{
                        Self.defaultColor.setFill()
                    }
                    let path = NSBezierPath()
                    path.appendRect(NSRect(x: xoffset + CGFloat(lev) * width, y: 0, width: 2, height: height))
                    path.fill()
                    if childIndex == index && node === startNode {
                        Self.selectedColor.setFill()
                        let path = NSBezierPath()
                        path.appendRect(NSRect(x: xoffset + CGFloat(lev) * width, y: 0, width: 2, height: yoffset+2))
                        path.fill()
                    }
                }else if node === startNode {
                    if childIndex == index {
                        Self.selectedColor.setFill()
                    }else{
                        Self.defaultColor.setFill()
                    }
                    let path = NSBezierPath()
                    path.appendRect(NSRect(x: xoffset + CGFloat(lev) * width, y: 0, width: 2, height: yoffset+2))
                    path.fill()
                }
                node = parent
                lev = outline.level(forItem: node)
            }
        }
    }
    
    func selectedArray() -> [NSTreeNode] {
        var res : [NSTreeNode] = []
        if let outlineView = outlineView {
            let row = outlineView.selectedRow
            if row >= 0 {
                var item = outlineView.item(atRow: row) as! NSTreeNode?
                while let node = item {
                    res.append(node)
                    item = outlineView.parent(forItem: node) as? NSTreeNode
                }
            }
        }
        return res
    }
}
