//
//  main.swift
//  Emanon
//
//  Created by sean on 30/10/2016.
//  Copyright © 2016 antfarm. All rights reserved.
//

import Foundation


let emanon = Emanon2()

for _ in 1...100 {

    emanon.createExpression(depth: 5)

    print(emanon.expression ?? "NO EXPRESSION")
    
    for x in 0 ..< 320 {
        for y in 0 ..< 320 {

            let result = try! emanon.evalExpression(x: Double(x), y: Double(y))

            //print("\(x) \(y): \(result)")

            let image = EmanonImage()
        }
    }

    print()
}
