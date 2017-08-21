//
//  ShoppingList.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation


class ShoppingList {
    
    private var storeAndItems: [String : [Item]]
    
    init(storeAndItems: [String : [Item]] = [:]) {
        self.storeAndItems = storeAndItems
    }
    
    func getNumberOfKeys() -> Int {
        return storeAndItems.count
    }
    
    func getTotalNumberOfItems() -> Int {
        var count: Int = 0
        
        for _ in storeAndItems {
            count += 1
        }
        
        return count
    }
    
    func createKey(keyName: String) {
        storeAndItems[keyName] = []
    }
    
    func addItemToKey(item: Item) {
        
        if storeAndItems[item.shoppingList] != nil {
            storeAndItems[item.shoppingList]?.append(item)
        }
    }
    
    func deleteEntry() {
        
    }
    
    func updateEntry() {
        
    }
}
