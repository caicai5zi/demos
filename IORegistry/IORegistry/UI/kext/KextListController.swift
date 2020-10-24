//
//  KextListController.swift
//  IOReg
//
//  Created by app on 2020/10/22.
//

import Foundation
import AppKit

class KextListController : NSViewController {
    static let SelectObject : Notification.Name = Notification.Name("SelectObject")
    
    let tableView = NSTableView()
    let scrollView = NSScrollView()
    let arrayController = NSArrayController()
    @objc dynamic var datas : [[String:Any]] = []
    var keyValueObservations : [NSKeyValueObservation] = []
    
    override func loadView() {
        let view = NSView()
        view.frame = NSRect(x: 0, y: 0, width: 500, height: 500)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        keyValueObservations.append(arrayController.observe(\.selectedObjects, options: [.new]) {(arrayController, change) in
            NotificationCenter.default.post(name: KextListController.SelectObject, object: arrayController, userInfo: nil)
            self.invalidateRestorableState()
        })
    }
    override func viewWillAppear() {
        if datas.count == 0 {
            loadData()
        }
        if let column = tableView.tableColumns.first {
            if column.width < 50 {
                column.width = 315
            }
        }
    }
    
    deinit {
        for item in keyValueObservations {
            item.invalidate()
        }
        keyValueObservations.removeAll()
    }
}

extension KextListController {
    func loadData() {
        datas.removeAll()
        let arr = OCUtil.kextInfoArray()
        datas.append(contentsOf: arr)
    }
    
    private func createUI() {
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (m) in
            m.left.top.equalToSuperview()
            m.bottom.right.equalToSuperview()
        }
        
        arrayController.bind(NSBindingName(rawValue: "content"), to: self, withKeyPath: "datas", options: nil)
        addColumns()
        
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.delegate = self
    }
    
    func addColumns() {
        let columns = [["name":"CFBundleIdentifier","title":"Identifier","width":315.0],
                       ["name":"CFBundleVersion","title":"Version","width":100.0],
                       ["name":"OSBundleCompatibleVersion","title":"CompatibleVersion","width":100.0],
                       ["name":"OSBundleIsInterface","title":"IsInterface","width":75.0],
                       ["name":"OSKernelResource","title":"Resource","width":75.0],
                       ["name":"OSBundlePath","title":"Path","width":700.0],
                       ["name":"OSBundleExecutablePath","title":"ExecutablePath","width":1000.0],
                       ["name":"OSBundleUUID","title":"UUID","width":300.0],
                       ["name":"OSBundleStarted","title":"Started","width":75.0],
                       ["name":"OSBundlePrelinked","title":"Prelinked","width":75.0],
                       ["name":"OSBundleLoadTag","title":"LoadTag","width":75.0],
                       ["name":"OSBundleLoadAddress","title":"LoadAddress","width":180.0],
                       ["name":"OSBundleLoadSize","title":"LoadSize","width":75.0],
                       ["name":"OSBundleWiredSize","title":"WiredSize","width":80.0],
                       ["name":"OSBundleDependencies","title":"Dependencies","width":150.0],
                       ["name":"OSBundleRetainCount","title":"RetainCount","width":75.0]
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

extension KextListController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else {
            return NSView()
        }
        var view : KextCell
        if let cell = tableView.makeView(withIdentifier: column.identifier, owner: nil) as? KextCell {
            view = cell
        }else{
            if column.identifier.rawValue == "OSBundleLoadAddress" {
                view = KextCell()
                view.textField?.font = NSFont(name: "menlo", size: 12)
                view.identifier = column.identifier
            }else{
                view = KextCell()
                view.identifier = column.identifier
            }
        }
        return view
    }
}
