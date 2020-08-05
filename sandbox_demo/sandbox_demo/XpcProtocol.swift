//
//  XpcProtocol.swift
//  sandbox_demo
//
//  Created by 李玉峰 on 2020/8/5.
//  Copyright © 2020 李玉峰. All rights reserved.
//

import Foundation

@objc protocol XpcProtocol {
    func test(_ cb: (Bool) -> Void)
}
