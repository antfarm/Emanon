import Foundation

enum EmanonError: Error {
    case noExpression
}

class Emanon {

    private(set) var expression: NSExpression?


    func createExpression(depth: Int) {

        let expressionString = Expression.randomExpression(maxDepth: depth)
        expression = NSExpression(format: expressionString)
    }


    func evalExpression(x: Double, y: Double) throws -> Double {

        guard let expression = expression else {
            throw EmanonError.noExpression
        }

        // http://stackoverflow.com/questions/40338759/nsexpression-memory-leak

        var value: Any!

        autoreleasepool {
            value = expression.expressionValue(with: ["x" : x, "y": y], context: nil)
        }

        return value as! Double
    }
}


class Expression {

    // http://nshipster.com/nsexpression/

    private static let terminalProductions = ["x", "y"]
    private static let nonterminalProductions = ["(_ * -1)", "(_ + _)", "(_ - _)", "(_ * _)"]
    private static let productions = terminalProductions + nonterminalProductions


    static func randomExpression(maxDepth: Int) -> String {

        return expandExpression(expression: "_", depth: maxDepth)
    }


    private static func expandExpression(expression: String, depth: Int) -> String {

        guard depth > 0 else {
            return singleExpansion(expression: expression, terminal: true)
        }

        let expansion = singleExpansion(expression: expression, terminal: false)

        guard expansion != expression else {
            return expression
        }

        return expandExpression(expression: expansion, depth: depth - 1)
    }


    private static func singleExpansion(expression: String, terminal: Bool = false) -> String {

        return expression.characters.reduce("") { (expr, ch) in

            if ch != "_" {
                return expr + String(ch)
            }

            return expr + (terminal ? self.terminalProductions : self.nonterminalProductions).randomItem()
//            return expr + (terminal ? self.terminalProductions : self.productions).randomItem()
        }
    }
}
