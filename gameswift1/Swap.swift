//
//  Swap.swift
//  gameswift1
//
//  Created by phamvanhung on 2015/07/04.
//  Copyright (c) 2015年 phamvanhung. All rights reserved.
//

struct Swap: Printable {
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}