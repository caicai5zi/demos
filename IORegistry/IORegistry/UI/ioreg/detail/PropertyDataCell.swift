//
//  PropertyDataCell.swift
//  IOReg
//
//  Created by app on 2020/10/21.
//

import Foundation

import Foundation
import AppKit

class PropertyDataCell : NSTableCellView {
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
        textField.font = NSFont(name: "menlo", size: 12)
        
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
