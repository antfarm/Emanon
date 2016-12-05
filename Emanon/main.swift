import Foundation


//typealias Emanon = EmanonEnum
typealias Emanon = EmanonClass
//typealias Emanon = EmanonString
//typealias Emanon = EmanonClass2


func main() {

    srand48(42)

    let emanon = Emanon()

    let sizeX = 100
    let sizeY = 100

    for _ in 1...100 {

//        var values = [[Double]]()

//        var maxValue = DBL_MIN
//        var minValue = DBL_MAX

        Time.printExecutionTime("eval: ") {

            emanon.createExpression(depth: 5)

            print(emanon.expressionString)

            for x in 0 ..< sizeX {

//                var row = [Double]()

                for y in 0 ..< sizeY {

                    let value = emanon.evalExpression(x: Double(x), y: Double(y))

//                    maxValue = max(value, maxValue)
//                    minValue = min(value, minValue)

                    //print("\(value) | \(minValue) ... \(maxValue)")

//                    row.append(value)
                }

//                values.append(row)
            }
        }


        //

//        var valuesNormalized = [[Double]]()
//
//        for row in values {
//            let rowNormalized = row.map { ($0 - minValue) / (maxValue - minValue)}
//            valuesNormalized.append(rowNormalized)
//        }

        //print("\(minValue) ... \(maxValue)")
        //
        //for rowNormalized in valuesNormalized {
        //    print("\(rowNormalized.min()!) ... \(rowNormalized.max()!)")
        //}
        
        print()
    }
}


Time.printExecutionTime("main: ") {
    main()
}
