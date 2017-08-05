//
//  Item.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation

struct Item {
    var itemId: Int
    var itemName: String
    var itemOwner: String
    var itemQuantity: Int
}

extension Item {
    func quantityToString() -> String {
        return String(self.itemQuantity)
    }
}
