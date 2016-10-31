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


let e = Emanon()

for _ in 1...100 {

    e.createExpression(depth: 8)
    
    print(e.expression)

    for x in 0 ..< 320 {
        for y in 0 ..< 320 {

            let result = e.evalExpression(x: Double(x), y: Double(y))
            print("\(x) \(y): \(result)")
        }
    }

    print()
}
