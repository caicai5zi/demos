//
//  KextSplitController.swift
//  IOReg
//
//  Created by app on 2020/10/22.
//

import Foundation
import AppKit

class KextSplitController : NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitView.isVertical = false
        
        let list = KextListController()
        self.addSplitViewItem(NSSplitViewItem(viewController: list))
        
        let classes = KextBundleClassesController()
        self.addSplitViewItem(NSSplitViewItem(viewController: classes))
        
        createUI()
    }
    
    func createUI() {
        let titleBar = NSView()
        let titleL = CAILabel()
        titleL.stringValue = "内核驱动"
        titleL.font = NSFont.systemFont(ofSize: 16)
        titleBar.addSubview(titleL)
        view.addSubview(titleBar)
        
        titleBar.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.height.equalTo(40)
        }
        
        titleL.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview()
        }
        
        splitView.snp.makeConstraints { (m) in
            m.left.right.equalTo(titleBar)
            m.top.equalTo(titleBar.snp.bottom)
            m.bottom.equalToSuperview()
        }
    }
}
