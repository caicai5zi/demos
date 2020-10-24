//
//  IORegViewController.swift
//  HRSword
//
//  Created by app on 2020/10/20.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation
import AppKit

class IORegViewController: NSViewController {
    
    var notifications : [NSObjectProtocol] = []
    
    let split = NSSplitViewController()
    
    let nameL = CAILabel()
    let ioClassName = CAILabel()
    let bundleId = CAILabel()
    let rCount = CAILabel()
    let busyCount = CAILabel()
    let registeredBtn = NSButton()
    let matchedBtn = NSButton()
    let activeBtn = NSButton()
    
    
    override func loadView() {
        let view = NSView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        let tree = IORegTreeController()
        split.addSplitViewItem(NSSplitViewItem(viewController: tree))
        let property = IORPropertyController()
        split.addSplitViewItem(NSSplitViewItem(viewController: property))
        split.splitView.isVertical = true
        
        
        notifications.append(NotificationCenter.default.addObserver(forName: IORegTreeController.SelectNode, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            if let tree = notification.object as? NSTreeController,
               tree.selectedNodes.count > 0
               {
                if let node = tree.selectedObjects[0] as? IONode  {
                    guard let self = self else {
                        return
                    }
                    self.nameL.stringValue = node.name
                    self.ioClassName.stringValue = node.ioClassName
                    self.bundleId.stringValue = node.bundleId
                    self.rCount.stringValue = "\(node.kernelRetainCount)"
                    self.busyCount.stringValue = "\(node.busyCount)"
                    self.matchedBtn.state = OCUtil.matched(node.entry) ? .on : .off
                }
            }
        })
    }
    
    deinit {
        for ntf in notifications {
            NotificationCenter.default.removeObserver(ntf)
        }
        notifications.removeAll()
    }
}

extension IORegViewController {
    func createUI() {
        let container = NSView()
        
        let titleBar = NSView()
        let titleL = CAILabel()
        titleL.stringValue = "设备树"
        titleL.font = NSFont.systemFont(ofSize: 16)
        titleBar.addSubview(titleL)
        container.addSubview(titleBar)

        let rightView = NSView()
        
        rCount.alignment = .right
        busyCount.alignment = .right
        
        ioClassName.maximumNumberOfLines = 2
        ioClassName.lineBreakMode = .byTruncatingTail
        
        registeredBtn.setButtonType(.switch)
        registeredBtn.title = "Registered"
        registeredBtn.isEnabled = false
        matchedBtn.setButtonType(.switch)
        matchedBtn.title = "Matched"
        matchedBtn.isEnabled = false
        activeBtn.setButtonType(.switch)
        activeBtn.title = "Active"
        activeBtn.isEnabled = false
        
        view.addSubview(container)
        let topView = NSView()
        container.addSubview(topView)
        
        topView.addSubview(rightView)
        
        topView.addSubview(nameL)
        let classl = CAILabel()
        classl.stringValue = "class"
        topView.addSubview(classl)
        topView.addSubview(ioClassName)
        
        let bundleL = CAILabel()
        bundleL.stringValue = "Bundle"
        topView.addSubview(bundleL)
        topView.addSubview(bundleId)
        
        let rCountL = CAILabel()
        rCountL.stringValue = "Retain Count:"
        rightView.addSubview(rCountL)
        rightView.addSubview(rCount)
        
        let busyCountL = CAILabel()
        busyCountL.stringValue = "Busy Count:"
        rightView.addSubview(busyCountL)
        rightView.addSubview(busyCount)
        
        rightView.addSubview(registeredBtn)
        rightView.addSubview(matchedBtn)
        rightView.addSubview(activeBtn)
        
        container.addSubview(split.view)
        
        container.snp.makeConstraints { (m) in
            m.top.left.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.bottom.equalToSuperview()
        }
        
        titleBar.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview()
            m.right.equalToSuperview()
            m.height.equalTo(40)
        }
        
        titleL.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview()
        }
        
        topView.snp.makeConstraints { (m) in
            m.top.equalTo(titleBar.snp.bottom)
            m.left.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.height.equalTo(80)
        }
        
        nameL.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview()
            m.right.lessThanOrEqualToSuperview()
        }
        
        classl.snp.makeConstraints { (m) in
            m.left.equalToSuperview()
            m.top.equalTo(nameL.snp.bottom).offset(10)
            m.width.equalTo(100)
        }
        
        ioClassName.snp.makeConstraints { (m) in
            m.left.equalTo(classl.snp.right).offset(10)
            m.top.equalTo(classl)
            m.right.lessThanOrEqualTo(rightView.snp.left).offset(-10)
        }
        ioClassName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        bundleL.snp.makeConstraints { (m) in
            m.left.equalToSuperview()
            m.bottom.equalToSuperview()
            m.width.equalTo(100)
        }
        
        bundleId.snp.makeConstraints { (m) in
            m.left.equalTo(classl.snp.right).offset(10)
            m.bottom.equalTo(bundleL)
            m.right.lessThanOrEqualToSuperview()
        }
        
        rightView.snp.makeConstraints { (m) in
            m.top.bottom.right.equalToSuperview()
        }
        
        rCount.snp.makeConstraints { (m) in
            m.top.right.equalToSuperview()
            m.width.equalTo(30)
        }
        rCountL.snp.makeConstraints { (m) in
            m.centerY.equalTo(rCount)
            m.right.equalTo(rCount.snp.left)
        }
        
        busyCount.snp.makeConstraints { (m) in
            m.right.equalToSuperview()
            m.top.equalTo(rCount.snp.bottom).offset(10)
            m.width.equalTo(30)
        }
        busyCountL.snp.makeConstraints { (m) in
            m.centerY.equalTo(busyCount)
            m.right.equalTo(busyCount.snp.left)
        }
        
        registeredBtn.snp.makeConstraints { (m) in
            m.centerY.equalTo(rCount)
            m.right.equalTo(rCountL.snp.left).offset(-20)
            m.left.equalToSuperview()
        }
        
        matchedBtn.snp.makeConstraints { (m) in
            m.left.equalTo(registeredBtn)
            m.top.equalTo(registeredBtn.snp.bottom).offset(10)
        }
        
        activeBtn.snp.makeConstraints { (m) in
            m.left.equalTo(registeredBtn)
            m.top.equalTo(matchedBtn.snp.bottom).offset(10)
        }
        
        split.view.snp.makeConstraints { (m) in
            m.left.right.bottom.equalToSuperview()
            m.top.equalTo(topView.snp.bottom).offset(20)
        }
    }
}
