//
//  XpcClient.swift
//  sandbox_demo
//
//  Created by 李玉峰 on 2020/8/5.
//  Copyright © 2020 李玉峰. All rights reserved.
//

import Cocoa

class XpcClient: NSObject {
    class Export : NSObject {
        
    }
    
    let client : NSXPCConnection = NSXPCConnection(serviceName: "com.caidev.sbXPC")
    func connect() {
        client.exportedInterface = NSXPCInterface(with: XpcProtocol.self)
        client.remoteObjectInterface = NSXPCInterface(with: XpcProtocol.self)
        client.exportedObject = Export()
        client.resume()
        
        if let proxy = client.synchronousRemoteObjectProxyWithErrorHandler({ (err) in
            print(err)
        }) as? XpcProtocol {
            proxy.test { (sec) in
                print(sec)
            }
        }
    }
}

extension XpcClient.Export : XpcProtocol {
    func test(_ cb: (Bool) -> Void) {
        cb(true)
    }
}
