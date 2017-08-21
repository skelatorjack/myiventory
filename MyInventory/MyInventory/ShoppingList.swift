//
//  ShoppingList.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation


class ShoppingList {
    
    private var listName: String
    private var storeAndItems: [String : [Item]]
    
    init(storeAndItems: [String : [Item]] = [:], listName: String = "") {
        self.storeAndItems = storeAndItems
        self.listName = listName
    }
    
    func getNumberOfKeys() -> Int {
        return storeAndItems.count
    }
    
    func getListName() -> String {
        return listName
    }
    
    func getStoresAndItems() -> [String : [Item]] {
        return storeAndItems
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
    
    func doesKeyExist(key: String) -> Bool {
        if storeAndItems[key] != nil {
            return true
        }
        return false
    }
    
    func getValue(key: String, index: Int) -> Item? {
        if doesKeyExist(key: key) && isIndexValidForValue(key: key, index: index) {
            let value = storeAndItems[key]?.map { $0 }
            
            return value?[index]
        }
        return nil
    }
    
    func deleteEntry() {
        
    }
    
    func updateEntry() {
        
    }
    
    func item(at index: Int) {
        
    }
    private func isIndexValidForValue(key: String, index: Int) -> Bool {
        if let value = storeAndItems[key]?.count,
            isIndexValid(index: index, MAX: value, MIN: 0){
            return true
        }
        return false
    }
    
    private func isIndexValid(index: Int, MAX: Int, MIN: Int) -> Bool {
        if index >= MAX || index < MIN {
            return false
        }
        return true
    }
    
}
