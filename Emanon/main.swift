//
//  main.swift
//  Emanon
//
//  Created by sean on 30/10/2016.
//  Copyright © 2016 antfarm. All rights reserved.
//

import Foundation
import CoreGraphics


let p: CGPoint = CGPoint(x: 0, y: 0)
print(p)


let emanon = Emanon()

for _ in 1...100 {

    emanon.createExpression(depth: 8)

    print(emanon.expression)
    
    for x in 0 ..< 320 {
        for y in 0 ..< 320 {

            let result = emanon.evalExpression(x: Double(x), y: Double(y))
            print("\(x) \(y): \(result)")
        }
    }

    print()
}
