//
//  IORegCell.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation
import AppKit

class IORegCell : NSTableCellView {
    
    override var objectValue: Any? {
        didSet {
            if let node = objectValue as? IONode,
               let identifier = identifier {
                if identifier.rawValue == "name" {
                    self.text = node.name
                }else if identifier.rawValue == "bundleId" {
                    self.text = node.bundleId
                }else if identifier.rawValue == "kernelRetainCount" {
                    self.text = "\(node.kernelRetainCount)"
                }
            }
        }
    }
    
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
        textField.lineBreakMode = .byTruncatingTail
        
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        addSubview(textField)
        
        self.textField = textField
        
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10).priority(.high)
            make.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}
