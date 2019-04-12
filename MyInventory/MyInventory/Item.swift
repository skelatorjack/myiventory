//
//  Item.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation

enum ItemType {
    case InventoryItem
    case ShoppingListItem
}

struct Item: Equatable {
    var itemName: String
    var itemOwner: String
    var itemQuantity: Int
    var shoppingList: String
    var shopName: String
    var itemCategory: ItemCategory
    var shoppingListID: UUID?
    
    init(newName: String = "", newOwner: String = "", newQuantity: Int = 0, newShoppingList: String = "", shopName: String = "",
         newCategory: ItemCategory = ItemCategory.Other, newListID: UUID? = nil) {
        self.itemName = newName
        self.itemOwner = newOwner
        self.itemQuantity = newQuantity
        self.shoppingList = newShoppingList
        self.shopName = shopName
        self.itemCategory = newCategory
        self.shoppingListID = newListID
    }
    
    static func == (left: Item, right: Item) -> Bool {
        if left.itemName == right.itemName,
            left.shoppingList == right.shoppingList,
            left.itemOwner == right.itemOwner,
            left.itemQuantity == right.itemQuantity,
            left.shopName == right.shopName,
            left.itemCategory == right.itemCategory,
            left.shoppingListID == right.shoppingListID {
            
            return true
        }
        return false
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
        
    }
    
    func isItemValid(itemType: ItemType) -> Bool {
        var isItemValid: Bool = false
        
        switch itemType {
        case .InventoryItem:
            isItemValid = isInventoryItemValid()
        
        case .ShoppingListItem:
            isItemValid = isShoppingListItemValid()
        }
        
        return isItemValid
    }
    
    func isInventoryItemValid() -> Bool {
        return isNameValid() && isQuantityValid()
    }
    
    func isShoppingListItemValid() -> Bool {
        return isInventoryItemValid() && isShoppingListValid()
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
    
    func isShoppingListValid() -> Bool {
        return !shoppingList.isEmpty
    }
    func isValueNotEqual(value: Int, to: Int) -> Bool {
        return value != to
    }
    
    mutating func clear() {
        self.itemOwner.removeAll()
        self.itemName.removeAll()
        self.itemQuantity = -1
        self.shoppingList.removeAll()
    }
}

extension Item {
    func quantityToString() -> String {
        return String(self.itemQuantity)
    }
}
