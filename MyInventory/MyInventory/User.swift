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
    
    func getItemList() -> [Item] {
        return itemList
    }
    
    func setItemList(itemList: [Item] = []) {
        self.itemList = itemList
    }
    
    func isItemInList(item: Item) -> Bool {
        return itemList.contains(item)
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
    
    func adaptItemModelToItemList(itemModels: [ItemModel]) {
        
        var items: [Item] = []
        
        if isListEmpty() && !itemModels.isEmpty {
            
            for model in itemModels {
            
                if let item = adaptItemModelToItem(itemModel: model) {
                    print("Item from core data is \(item)")
                    items.append(item)
                }
            }
        
            setItemList(itemList: items)
        }
    }
    
    func adaptItemModelToItem(itemModel: ItemModel) -> Item? {
        
        let quant = Int(itemModel.quantityOfItem)
        
        guard let name = itemModel.name,
            let owner = itemModel.ownerOfItem,
            let shoppingList = itemModel.shoppingListId else {
                
                return nil
        }
        
        return Item(newName: name, newOwner: owner, newQuantity: quant, newShoppingList: shoppingList)
    }
    
    func adatpItemToItemModel(itemToUpdate: Item) -> ItemModel {
        
        return ItemModel()
    }
    private func isIndexValid(index: Int) -> Bool {
        if index >= itemList.count || index < 0 {
            return false
        }
        return true
    }
}
