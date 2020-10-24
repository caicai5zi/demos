//
//  String.swift
//  HRSword
//
//  Created by app on 2020/10/15.
//  Copyright © 2020 cn.huorong. All rights reserved.
//

import Foundation



extension String {
    @objc enum SearchType: Int {
        case contains
        case ignoringCase
        case regularExpression
    }
    
    func Search(_ searchW : String, type:SearchType = .contains, defaultRes:Bool = false) -> Bool {
        var res = false
        switch type {
        case .contains:
            res = self.contains(searchW)
        case .ignoringCase:
            res = self.lowercased().contains(searchW.lowercased())
        case .regularExpression:
            do {
                let regex = try NSRegularExpression(pattern: searchW, options: [])
                if let _ = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
                    res = true
                }else {
                    res = false
                }
            } catch {
                res = defaultRes
            }
        }
        return res
    }
    
    func rangeOfSearch(_ sw:String, type : SearchType = .contains) -> [NSTextCheckingResult] {
        var res : [NSTextCheckingResult] = []
        do {
            var str = self
            var searchw = sw
            switch type {
            case .contains:
                break
            case .ignoringCase:
                str = str.lowercased()
                searchw = searchw.lowercased()
            case .regularExpression:
                break
            }
            let regex = try NSRegularExpression(pattern: searchw, options: [])
            let results = regex.matches(in: str, options: [], range: NSRange(location: 0, length: self.count))
            res.append(contentsOf: results)
        } catch {
            print(error)
        }
        return res
    }
}
