//
//  IONode.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation

class IONode : NSObject {
    var entry : io_registry_entry_t = 0 {
        didSet{
            fillInfo()
        }
    }
    @objc dynamic var children = [IONode]()
    @objc dynamic var leaf: Bool = false
    @objc dynamic var property : [AnyHashable:Any] = [:]
    @objc dynamic var bundleId : String = ""
    @objc dynamic var kernelRetainCount : UInt32 = 0
    @objc dynamic var count : Int {
        return children.count
    }
    
    @objc dynamic var name : String = ""
    lazy var ioClassName : String = {
        return OCUtil.ioObjectGetClasses(entry)
    }()
    lazy var busyCount : UInt32 = {
        return OCUtil.busyState(entry)
    }()
    
    private func fillInfo() {
        if entry != 0 {
            name = OCUtil.ioRegistryEntryGetName(inPlane: entry, plane: kIOServicePlane)
            property = OCUtil.properties(entry)
            bundleId = OCUtil.bundleIdentifier(forEntry: entry) ?? ""
            kernelRetainCount = IOObjectGetKernelRetainCount(entry)
        }
    }
    
    deinit {
        if entry != 0 {
            IOObjectRelease(entry)
            entry = 0
        }
    }
}

extension IONode {
    func updateLeaf() {
        self.leaf = children.count == 0
    }
}
