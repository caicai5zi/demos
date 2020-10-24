//
//  MainWindowController.swift
//  HRLaunchd
//
//  Created by app on 2020/8/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window {
            window.isOpaque = false
//            window.backgroundColor = NSColor.clear
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask = [.titled,
                                      .closable,
                                      .miniaturizable,
                                      .resizable,
                                      .fullSizeContentView
            ]//系统默认
        }

        if let size = NSScreen.main?.frame.size {
            window?.setContentSize(NSSize(width: size.width, height: size.height))
        }
    }
}
