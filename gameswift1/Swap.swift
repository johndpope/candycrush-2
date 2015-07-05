//
//  Swap.swift
//  gameswift1
//
//  Created by phamvanhung on 2015/07/04.
//  Copyright (c) 2015年 phamvanhung. All rights reserved.
//

struct Swap: Printable,Hashable {
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    var hashValue: Int {
        return cookieA.hashValue ^ cookieB.hashValue
    }
   
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}
func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
        (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}