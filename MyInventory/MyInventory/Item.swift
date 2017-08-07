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
    
    mutating func parseData(name: String, quantity: String, owner: String) {
        if !name.isEmpty {
            itemName = name
        }
        
        if !quantity.isEmpty {
            itemQuantity = Int(quantity)!
        }
        
        if !owner.isEmpty {
            itemOwner = owner
        }
        
        itemId = 1
    }
    
    func isItemValid() -> Bool {
        if isIdValid(), isNameValid(), isOwnerValid(), isQuantityValid() {
            return true
        }
        return false
    }
    
    func isIdValid() -> Bool {
        return isValueNotEqual(value: itemId, to: -1)
    }
    
    func isNameValid() -> Bool {
        return !itemName.isEmpty
    }
    
    func isOwnerValid() -> Bool {
        return !itemOwner.isEmpty
    }
    
    func isQuantityValid() -> Bool {
        return isValueNotEqual(value: itemQuantity, to: -1)
    }
    
    func isValueNotEqual(value: Int, to: Int) -> Bool {
        return value != to
    }
    
}

extension Item {
    func quantityToString() -> String {
        return String(self.itemQuantity)
    }
}
