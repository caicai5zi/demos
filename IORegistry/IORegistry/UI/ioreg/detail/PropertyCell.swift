//
//  PropertyCell.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation
import AppKit
import SnapKit

class PropertyCell : NSTableCellView {
    @objc dynamic var text : String = "" {
        didSet{
            self.textField?.stringValue = text
        }
    }
    
    init() {
        super.init(frame: NSZeroRect)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }
    
    deinit {
        self.unbind(NSBindingName("text"))
        textField?.unbind(NSBindingName("value"))
    }

    func createUI() {
        let textField = NSTextField()
        textField.isBordered = false
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = true
        textField.maximumNumberOfLines = 0
        
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        addSubview(textField)
        
        self.textField = textField
        
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}
