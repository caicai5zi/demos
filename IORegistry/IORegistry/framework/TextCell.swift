//
//  TextCell.swift
//  HRLaunchd
//
//  Created by app on 2020/8/4.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Cocoa

class TextCell: NSTableCellView {
    var searchString:String = "" {
        didSet{
            showSearch()
        }
    }
    @objc dynamic var text : String = "" {
        didSet{
            showSearch()
        }
    }//用于修改样式的时候保持原来的内容
    
    var endEdit : ((TextCell) -> Void)? = nil
    
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
        textField.delegate = self
        textField.isBordered = false
        textField.backgroundColor = NSColor.clear
        textField.isEditable = false
        textField.lineBreakMode = .byTruncatingMiddle
        addSubview(textField)
        self.textField = textField
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func showSearch() {
        if let textField = self.textField, searchString.count > 0 && self.text.count > 0 {
            let results = self.text.rangeOfSearch(searchString, type: Local.preference.searchType)
            let atString = NSMutableAttributedString(string: self.text)
            if results.count != 0 {
                for item in results {
                    atString.addAttribute(.backgroundColor, value: NSColor.systemYellow, range: item.range)
                }
            }
            let par = NSMutableParagraphStyle()
            par.lineBreakMode = textField.lineBreakMode
            atString .addAttribute(NSAttributedString.Key.paragraphStyle, value: par, range: NSRange(location: 0, length: atString.length))
            textField.attributedStringValue = atString
        } else {
            self.textField?.stringValue = self.text
        }
    }
}

extension TextCell : NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        if let endEdit = endEdit {
            endEdit(self)
        }
    }
}
