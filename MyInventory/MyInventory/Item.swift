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
    
    init(newId: Int = -1, newName: String = "", newOwner: String = "", newQuantity: Int = 0) {
        self.itemId = newId
        self.itemName = newName
        self.itemOwner = newOwner
        self.itemQuantity = newQuantity
    }
    
    func isItemValid() -> Bool {
        if isIdValid(), isNameValid(), isOwnerValid(), isQuantityValid() {
            return true
        }
        return false
    }
    
    func isIdValid() -> Bool {
        return itemId != -1
    }
    
    func isNameValid() -> Bool {
        return itemName != ""
    }
    
    func isOwnerValid() -> Bool {
        return itemOwner != ""
    }
    
    func isQuantityValid() -> Bool {
        return itemQuantity != -1
    }
    
}

extension Item {
    func quantityToString() -> String {
        return String(self.itemQuantity)
    }
}
