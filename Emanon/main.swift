import Foundation


protocol Emanon {

    var expressionString: String {get}

    func createExpression(depth: Int)

    func evalExpression(x: Double, y: Double) -> Double
}


func benchmark(emanon: Emanon) -> (Double, Double, Double) {

    var timeCreateTotal = Double(0)
    var timeStringTotal = Double(0)
    var timeEvalTotal = Double(0)

    srand48(42)

    let sizeX = 100
    let sizeY = 100

    for _ in 1...100 {

        let (timeCreate, _) = Time.measureExecutionTime {
            emanon.createExpression(depth: 5)
        }

         let (timeString, _) = Time.measureExecutionTime {
            let _ = emanon.expressionString
        }

        let (timeEval, _) = Time.measureExecutionTime {
            for x in 0 ..< sizeX {
                for y in 0 ..< sizeY {
                    let _ = emanon.evalExpression(x: Double(x), y: Double(y))
                }
            }
        }

        timeCreateTotal += timeCreate
        timeStringTotal += timeString
        timeEvalTotal += timeEval
    }

    return (timeCreateTotal, timeStringTotal, timeEvalTotal)
}


func main() {

    let emanons: [Emanon] = [EmanonString(), EmanonEnum(), EmanonList(), EmanonPolymorphism()]

    for emanon in emanons {
        print("\(type(of: emanon))")
        let (timeCreateTotal, timeStringTotal, timeEvalTotal) = benchmark(emanon: emanon)
        print("\t\(timeCreateTotal) \t\(timeStringTotal) \t\(timeEvalTotal)")
    }
}


main()


//func main() {
//
//    srand48(42)
//
//    let emanon = Emanon()
//
//    let sizeX = 100
//    let sizeY = 100
//
//    for _ in 1...100 {
//
//        var values = [[Double]]()
//
//        var maxValue = DBL_MIN
//        var minValue = DBL_MAX
//
//        Time.printExecutionTime("eval: ") {
//
//            emanon.createExpression(depth: 5)
//
//            //print(emanon.expressionString)
//
//            for x in 0 ..< sizeX {
//
//                var row = [Double]()
//
//                for y in 0 ..< sizeY {
//
//                    let value = emanon.evalExpression(x: Double(x), y: Double(y))
//
//                    maxValue = max(value, maxValue)
//                    minValue = min(value, minValue)
//
//                    //print("\(value) | \(minValue) ... \(maxValue)")
//
//                    row.append(value)
//                }
//
//                values.append(row)
//            }
//        }
//
////        var valuesNormalized = [[Double]]()
////
////        for row in values {
////            let rowNormalized = row.map { ($0 - minValue) / (maxValue - minValue)}
////            valuesNormalized.append(rowNormalized)
////        }
////
////        print("\(minValue) ... \(maxValue)")
////
////        for rowNormalized in valuesNormalized {
////            print("\(rowNormalized.min()!) ... \(rowNormalized.max()!)")
////        }
////
////        print()
//    }
//}
