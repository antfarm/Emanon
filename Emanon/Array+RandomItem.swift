//
//  Array+randomItem.swift
//  Emanon
//
//  Created by sean on 31/10/2016.
//  Copyright © 2016 antfarm. All rights reserved.
//

import Foundation


extension Array {

    func randomItem() -> Element {

        let index = Int(arc4random_uniform(UInt32(self.count)))

        return self[index]
    }
}
