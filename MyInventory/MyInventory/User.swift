//
//  User.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
// Model Class


class User {
    private var itemList: [Item]
    
    init(itemList: [Item] = []) {
        self.itemList = itemList
    }
    
    func item(at index: Int) -> Item? {
        if isIndexValid(index: index) {
            return itemList[index]
        }
        return nil
    }
    
    func add(item: Item) {
        itemList.append(item)
    }
    
    func delete(at index: Int) {
        if self.item(at: index) != nil {
            itemList.remove(at: index)
        }
    }
    
    func updateItem(at index: Int, with item: Item) {
        if self.item(at: index) != nil {
            itemList[index] = item
        }
    }
    
    func getItemCount() -> Int {
        return itemList.count
    }
    
    func isListEmpty() -> Bool {
        return itemList.isEmpty
    }
    
    private func isIndexValid(index: Int) -> Bool {
        if index >= itemList.count || index < 0 {
            return false
        }
        return true
    }
}
