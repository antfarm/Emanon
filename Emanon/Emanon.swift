import Foundation


class Emanon {

    var expression: NSExpression!


    func createExpression(depth: Int) {

        let expressionString = ExpressionTree.randomExpression(maxDepth: depth)
        expression = NSExpression(format: expressionString)
    }


    func evalExpression(x: Double, y: Double) -> Double {

        // http://stackoverflow.com/questions/40338759/nsexpression-memory-leak

        var value: Any!

        autoreleasepool {
            value = expression.expressionValue(with: ["x" : x, "y": y], context: nil)
        }

        return value as! Double
    }
}


extension Array {

    func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}


class ExpressionTree {

    static let terminalProductions = ["x", "y"]
    static let nonterminalProductions = ["(_ * -1)", "(_ + _)", "(_ - _)", "(_ * _)"]
    static let productions = terminalProductions + nonterminalProductions


    static func randomExpression(maxDepth: Int) -> String {

        return expandExpression(expression: "_", depth: maxDepth)
    }


    static func expandExpression(expression: String, depth: Int) -> String {

        if depth == 0 {
            return singleExpansion(expression: expression, terminal: true)
        }

        let expansion = singleExpansion(expression: expression, terminal: false)

        if expansion == expression {
            return expression
        }

        return expandExpression(expression: expansion, depth: depth - 1)
    }


    static func singleExpansion(expression: String, terminal: Bool = false) -> String {

        return expression.characters.reduce("") { (expr, ch) in

            if ch != "_" {
                return expr + String(ch)
            }

            return expr + (terminal ? self.terminalProductions : self.productions).randomItem()
        }
    }
}
