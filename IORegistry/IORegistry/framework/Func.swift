//
//  Func.swift
//  IORegistry
//
//  Created by caicai on 2020/10/24.
//

import Foundation

func descriptionMemorySize(_ size:Double) -> String {
    var res = ""
    let units = ["byte","k","M","G","T","P","E"]
    if size < pow(2, 10) {
        res = String(format: "%dbyte", Int(size))
    }else{
        let numbers:[Double] = [pow(2, 10),pow(2, 20),pow(2, 30),pow(2, 40),pow(2, 50),pow(2, 60)]
        for i in 0 ..< numbers.count {
            let number = numbers[i]
            if size < number {
                var show = size
                if i > 0 {
                    show = show/numbers[i-1]
                }
                res = String(format: "%.2f%@", show,units[i])
                return res
            }
        }
        res = String(format: "%.02f%@", size/pow(2, 60),"E")
        return res
    }
    return res
}
