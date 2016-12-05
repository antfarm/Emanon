import Foundation


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
