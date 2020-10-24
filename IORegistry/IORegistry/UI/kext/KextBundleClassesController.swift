//
//  KextBundleClassesController.swift
//  IOReg
//
//  Created by app on 2020/10/22.
//

import Foundation
import AppKit

class KextBundleClassesController : NSViewController {
    
    let tableView = NSTableView()
    let scrollView = NSScrollView()
    let classLable = CAILabel()
    let arrayController = NSArrayController()
    @objc dynamic var datas : [[String:Any]] = []
    var notifications : [NSObjectProtocol] = []
    var keyValueObservations : [NSKeyValueObservation] = []
    
    
    override func loadView() {
        let view = NSView()
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 300)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        notifications.append(NotificationCenter.default.addObserver(forName: KextListController.SelectObject, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            if let tree = notification.object as? NSArrayController,
               tree.selectedObjects.count > 0
               {
                if let node = tree.selectedObjects[0] as? [String:Any],
                   let classes = node["OSBundleClasses"] as? [[String:Any]] {
                    guard let self = self else {
                        return
                    }
                    self.datas.removeAll()
                    self.datas.append(contentsOf: classes)
                }else{
                    self?.datas.removeAll()
                }
            }
        })
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        if let column = tableView.tableColumns.first {
            if column.width < 50 {
                column.width = 350
            }
        }
    }
    
    deinit {
        for item in notifications {
            NotificationCenter.default.removeObserver(item)
        }
        notifications.removeAll()
        for item in keyValueObservations {
            item.invalidate()
        }
        keyValueObservations.removeAll()
    }
}

extension KextBundleClassesController {
    
    private func createUI() {
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        view.addSubview(scrollView)
        let bottomView = NSView()
        bottomView.addSubview(classLable)
        let line = NSTextField()
        line.isBordered = false
        line.isEnabled = false
        line.backgroundColor = NSColor.systemGray
        bottomView.addSubview(line)
        view.addSubview(bottomView)
        scrollView.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview()
            m.right.equalToSuperview()
            m.bottom.equalToSuperview().offset(-25)
        }
        bottomView.snp.makeConstraints { (m) in
            m.left.right.bottom.equalToSuperview()
            m.top.equalTo(scrollView.snp.bottom)
        }
        
        line.snp.makeConstraints { (m) in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(1)
        }
        
        classLable.snp.makeConstraints { (m) in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().offset(10)
            m.right.equalToSuperview().offset(-10)
        }
        
        arrayController.bind(NSBindingName(rawValue: "contentArray"), to: self, withKeyPath: "datas", options: nil)
        addColumns()
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.delegate = self
        
        keyValueObservations.append(arrayController.observe(\.selectedObjects, options: [.new]) {[weak self] (arrayController, change) in
            guard let self = self else { return }
            if let dic = arrayController.selectedObjects.first as? [String:Any] ,
               let className = dic["OSMetaClassName"] as? String {
                self.classLable.stringValue = OCUtil.ioObjectClassInherit(className).joined(separator: " : ")
            }else{
                self.classLable.stringValue = ""
            }
            self.invalidateRestorableState()
        })
    }
    
    func addColumns() {
        let columns = [["name":"OSMetaClassName","title":"ClassName","width":350.0],
                       ["name":"OSMetaClassSuperclassName","title":"SuperclassName","width":350.0],
                       ["name":"OSMetaClassTrackingCount","title":"TrackingCount","width":150.0]
        ]
        for dic in columns {
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(dic["name"] as! String))
            column.title = dic["title"] as! String
            column.width = CGFloat(dic["width"] as! Double)
            column.bind(NSBindingName("value"), to: arrayController, withKeyPath: "ararrangedObjects", options: nil)
            column.sortDescriptorPrototype = NSSortDescriptor(key: dic["name"] as? String, ascending: true)
            column.headerCell.alignment = .center
            tableView.addTableColumn(column)
        }
        tableView.columnAutoresizingStyle = .noColumnAutoresizing
    }
}

extension KextBundleClassesController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else {
            return NSView()
        }
        var view : KextCell
        if let cell = tableView.makeView(withIdentifier: column.identifier, owner: nil) as? KextCell {
            view = cell
        }else{
            view = KextCell()
            view.identifier = column.identifier
        }
        return view
    }
}
