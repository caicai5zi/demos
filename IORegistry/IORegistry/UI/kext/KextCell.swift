//
//  KextCell.swift
//  IOReg
//
//  Created by app on 2020/10/22.
//

import Cocoa



class KextCell: NSTableCellView {

    override var objectValue: Any? {
        didSet{
            if let dic = objectValue as? [String:Any] , let identifier = self.identifier {
                if let value = dic[identifier.rawValue] {
                    if identifier.rawValue == "OSBundleDependencies" {
                        if let value = value as? [Int] {
                            var dependences : [String] = []
                            for item in value {
                                dependences.append(String(item))
                            }
                            self.text = dependences.joined(separator: ",")
                        }else{
                            self.text = ""
                        }
                    }else if identifier.rawValue == "OSBundleLoadAddress" {
                        if let value = value as? NSNumber {
                            self.text = String(format: "0X%016llx", value.uint64Value)
                        }
                    }else if identifier.rawValue == "OSBundleLoadSize" ||
                                identifier.rawValue == "OSBundleWiredSize"{
                        if let value = value as? NSNumber {
                            self.text = descriptionMemorySize(value.doubleValue)
                        }
                    }
                    else{
                        if let value = value as? String {
                            self.text = value
                        }else if let value = value as? NSNumber {
                            self.text = "\(value)"
                        }else if let value = value as? Data {
                            var byte = [UInt8](value)
                            let uuid = NSUUID(uuidBytes: &byte)
                            self.text = uuid.uuidString
                        }else if let value = value as? NSNumber {
                            self.text = value.stringValue
                        }
                        else{
                            self.text = "\(value)"
                        }
                    }
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
