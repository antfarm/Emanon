//
//  main.swift
//  Emanon
//
//  Created by sean on 30/10/2016.
//  Copyright © 2016 antfarm. All rights reserved.
//

import Foundation


//typealias Emanon = EmanonEnum
typealias Emanon = EmanonClass
//typealias Emanon = EmanonString


func main() {

    srand48(42)

    let emanon = Emanon()

    let sizeX = 100
    let sizeY = 100

    for _ in 1...100 {

        emanon.createExpression(depth: 5)

        print(emanon.expressionString)

        var values = [[Double]]()

        var maxValue = DBL_MIN
        var minValue = DBL_MAX

        for x in 0 ..< sizeX {

            var row = [Double]()

            for y in 0 ..< sizeY {

                let value = emanon.evalExpression(x: Double(x), y: Double(y))

                maxValue = max(value, maxValue)
                minValue = min(value, minValue)

                //print("\(value) | \(minValue) ... \(maxValue)")

                row.append(value)
            }

            values.append(row)
        }

        //print("\(minValue) ... \(maxValue)")

        //

        var valuesNormalized = [[Double]]()

        for row in values {
            let rowNormalized = row.map { ($0 - minValue) / (maxValue - minValue)}
            valuesNormalized.append(rowNormalized)
        }

        //for rowNormalized in valuesNormalized {
        //    print("\(rowNormalized.min()!) ... \(rowNormalized.max()!)")
        //}
        
        print()
    }
}


class Time {

    static func printExecutionTime<T>(_ label: String, action: () -> T) -> T  {

        let (duration, result) = measureExecutionTime {
            return action()
        }

        print("\(label): \(duration)")

        return result
    }


    static func measureExecutionTime<T>(_ action: () -> T) -> (Double, T)  {

        let start = Date()
        let result: T = action()
        let end = Date()

        let duration: Double = end.timeIntervalSince(start)
        return (duration, result)
    }
}


Time.printExecutionTime("main: ") {
    main()
}
