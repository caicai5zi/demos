//
//  PropertyNode.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation

@objc enum PropertyType : Int {
    case unknown
    case array
    case dictionary
    case boolean
    case date
    case data
    case number
    case string
    
    func description() -> String {
        var res = "unknown"
        switch self {
        case .array:
            res = "Array"
        case .dictionary:
            res = "Dictionary"
        case .boolean:
            res = "BOOL"
        case .date:
            res = "Date"
        case .data:
            res = "Data"
        case .number:
            res = "Number"
        case .string :
            res = "String"
        default:
            res = "unknown"
        }
        return res
    }
}

class PropertyNode : NSObject {
    @objc dynamic var children = [PropertyNode]()
    @objc dynamic var leaf: Bool = false
    @objc dynamic var isLeaf : Bool {
        return children.count == 0
    }
    
    @objc dynamic var key : String = ""
    var type : PropertyType = .unknown
    var value : Any? = nil
    var width : CGFloat = 0
    
    lazy var dataString : String? = {
        do {
            if let value = value as? Data, let str = String(data: value, encoding: .utf8) {
                return String(format: "<\"%@\">", str.replacingOccurrences(of: "\0", with: "\",\""))
            }else{
                return nil
            }
        }
    }()
    
    lazy var dataDes : String? = {
        if let value = value as? Data {
            let bytes = [UInt8](value)
            var res = ""
            for i in 0 ..< value.count {
                res.append(String(format: "%02x ", bytes[i]))
            }
            res.removeLast()
            return res
        }else{
            return nil
        }
    }()
    
    init(key:AnyHashable,value:Any) {
        super.init()
        if let key = key as? String {
            self.key = key
        }else if let key = key as? Int {
            self.key = "\(key)"
        }
        
        if value is Array<Any> {
            type = .array
        }else if value is Dictionary<AnyHashable,Any> {
            type = .dictionary
        }else if value is Bool {
            type = .boolean
        }else if value is Date {
            type = .date
        }else if value is Data {
            type = .data
        }else if value is Int {
            type = .number
        }else if value is String {
            type = .string
        }else{
            type = .unknown
        }
        self.value = value
    }
    
    func updateLeaf() {
        self.leaf = children.count == 0
    }
}
