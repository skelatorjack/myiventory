//
//  Extensions.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/24/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation

// get element at index

extension Array {
    func at(index: Int) -> Element? {
        if (index < 0 || index >= self.count) {
            return nil
        }
        return self[index]
    }
}

