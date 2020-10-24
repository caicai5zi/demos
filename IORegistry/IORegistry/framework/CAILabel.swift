//
//  CAILabel.swift
//  HRSword
//
//  Created by app on 2020/9/23.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Cocoa

class CAILabel: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        allInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        allInit()
    }
    
    private func allInit() {
        self.isEditable = false
        self.isBordered = false
        self.backgroundColor = NSColor.clear
    }
    
    override func layout() {
        var needwidth:CGFloat = 0
        if let cell = self.cell {
            let width = cell.cellSize(forBounds: NSRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(MAXFLOAT))).width
            needwidth = width
        }
        super.layout()
        if needwidth > self.bounds.size.width {
            self.toolTip = self.stringValue
            print(self.stringValue)
        }
    }
}
