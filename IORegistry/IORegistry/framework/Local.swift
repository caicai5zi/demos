//
//  LocalPreferense.swift
//  HRSword
//
//  Created by app on 2020/10/15.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation

class Local: NSObject {
    static let preference = Local()
    
    @objc dynamic var searchType : String.SearchType = .ignoringCase
}
