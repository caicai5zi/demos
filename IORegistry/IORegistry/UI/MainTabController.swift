//
//  MainTabController.swift
//  IORegistry
//
//  Created by caicai on 2020/10/24.
//

import Foundation
import AppKit

class MainTabController : NSTabViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ioreg = IORegViewController()
        addTabViewItem(NSTabViewItem(viewController: ioreg))
        
        let kext = KextSplitController()
        addTabViewItem(NSTabViewItem(viewController: kext))
        
        let ioregtable = IORegTreeTable()
        addTabViewItem(NSTabViewItem(viewController: ioregtable))
    }
}
