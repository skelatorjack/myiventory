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
    
    func setListName(name: String) {
        listName = name
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
    
    func getTotalNumberOfItemsInList() -> Int {
        let listOfShops: [String] = Array(storeAndItems.keys)
        var totalCount: Int = 0
        
        for shopName in listOfShops {
            totalCount += calculateTotalNumberOfItems(with: shopName)
        }
        
        return totalCount
    }
    
    func calculateTotalNumberOfItems(with key: String) -> Int {
        var totalCountInShop: Int = 0
        
        if let countFromKey = getNumberOfItems(with: key) {
            totalCountInShop += countFromKey
        }
        
        return totalCountInShop
    }
    
    func getNumberOfItems(with key: String) -> Int? {
        if doesKeyExist(key: key) {
            return storeAndItems[key]?.count
        }
        return nil
    }
    
    func getItemList(with key: String) -> [Item] {
        guard let itemList = storeAndItems[key] else {
            return []
        }
        return itemList
    }
    
    func createKey(keyName: String) {
        storeAndItems[keyName] = []
    }
    
    func addItemToKey(item: Item) {
        
        if storeAndItems[item.shopName] != nil {
            storeAndItems[item.shopName]?.append(item)
        }
    }
    
    func doesKeyExist(key: String) -> Bool {
        if storeAndItems[key] != nil {
            return true
        }
        return false
    }
    
    func getValue(key: String, index: Int) -> Item? {
        if isValidItem(key: key, index: index) {
            let value = storeAndItems[key]?.map { $0 }
            
            return value?[index]
        }
        return nil
    }
    
    func setValue(key: String, index: Int, item: Item) {
        if isValidItem(key: key, index: index) {
            setItemInShoppingList(key: key, index: index, newItem: item)
        }
    }
    
    func setItemInShoppingList(key: String, index: Int, newItem: Item) {
        if storeAndItems[key]?.at(index: index) != nil {
            storeAndItems[key]?[index] = newItem
        }
    }
    
    func isValidItem(key: String, index: Int) -> Bool {
        return doesKeyExist(key: key) && isIndexValidForValue(key: key, index: index)
    }
    
    func deleteEntry(key: String, index: Int) {
        if isIndexValidForValue(key: key, index: index) {
            storeAndItems[key]?.remove(at: index)
        }
    }
    
    func deleteKey(key: String) {
        storeAndItems.removeValue(forKey: key)
    }
    
    func updateEntry(item: Item, indexOfUpdate: Int) {
        setValue(key: item.shopName, index: indexOfUpdate, item: item)
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
    
    // This method changes all items shopping list to match the shoppinglist name
    func updateItemsInShoppingList() {
        let LIST_OF_KEYS: [String] = getStores()
        
        for key in LIST_OF_KEYS {
            for (index, item) in getItemList(with: key).enumerated() {
                setItemInShoppingList(key: key, index: index, newItem: changeShoppingList(oldItem: item))
            }
        }
    }
    
    private func doShoppingListNamesMatch(itemShoppingList: String) -> Bool {
        return getListName() == itemShoppingList
    }
    
    private func getStores() -> [String] {
        return Array(storeAndItems.keys)
    }
    
    private func changeShoppingList(oldItem: Item) -> Item {
        var newItem: Item = oldItem
        
        newItem.shoppingList = getListName()
        
        return newItem
    }
    
    private func moveItem(newListName: String, section: String, index: Int) {
        
    }
}
