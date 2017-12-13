//
//  User.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import CoreData

// Model Class


class User {
    private var itemList: [Item]
    private var coreDataInterface: CoreDataObject
    private var shoppingLists: [ShoppingList]
    
    init(itemList: [Item] = [], appDel: AppDelegate, shoppingLists: [ShoppingList] = []) {
        self.itemList = itemList
        
        let managedContext =
            appDel.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        let entity = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedContext)
        
        self.coreDataInterface = CoreDataObject(appDel: appDel, managedContext: managedContext, fetchReq: fetchRequest, entity: entity!)
        
        self.shoppingLists = shoppingLists

    }
    
    private func isIndexValid(index: Int) -> Bool {
        if index >= itemList.count || index < 0 {
            return false
        }
        return true
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
    
    func getIndexOfItem(itemToFind: Item) -> Int? {
        return itemList.index(of: itemToFind)
    }
    
    func getShoppingLists() -> [ShoppingList] {
        return shoppingLists
    }
    
    func getNumberOfItemsFromCoreData() -> Int {
        return coreDataInterface.getNumberOfItemsPersisted()
    }
    
    private func doesShoppingListContain(shopList: ShoppingList) -> Bool {
        for shoppingList in shoppingLists {
            if shoppingList.getListName() == shoppingList.getListName() {
                return true
            }
        }
        return false
    }

    func setUpShoppingLists() {
        
        for item in itemList {
            let newShoppingList: ShoppingList = ShoppingList(listName: item.shoppingList)
            
            if !doesShoppingListContain(shopList: newShoppingList) && !item.shoppingList.isEmpty {
                shoppingLists.append(newShoppingList)
            }
        }
    }
    
    func addItemsToShoppingLists() {
        let shoppingList: ShoppingList = ShoppingList()
        
        for item in itemList {
            if shoppingList.doesKeyExist(key: item.shoppingList) {
                shoppingList.addItemToKey(item: item)
            }
            else {
                shoppingList.createKey(keyName: item.shoppingList)
                shoppingList.addItemToKey(item: item)
            }
        }
        
        shoppingLists.append(shoppingList)
    }
    
    func add(item: Item) {
        // itemList.append(item)
        coreDataInterface.saveItem(item: item, itemList: &itemList)
    }
    
    func delete(at index: Int) {
        if let item = self.item(at: index) {
            coreDataInterface.deleteItem(itemToDelete: item, indexToDelete: index, itemList: &itemList)
        }
    }
    
    func updateItem(at index: Int, with item: Item) {
        if let oldItem = self.item(at: index) {
            coreDataInterface.updateItem(oldItem: oldItem, newItem: item, indexOfUpdate: index, itemList: &itemList)
        }
    }
    
    func getItemCount() -> Int {
        return itemList.count
    }
    
    func isListEmpty() -> Bool {
        return itemList.isEmpty
    }
    
    // Converts data fetched from CoreData to Items and sets the array to the itemlist
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
    
    func fetchFromCoreData() {
        let itemModels: [ItemModel] = coreDataInterface.fetchSavedData()
        adaptItemModelToItemList(itemModels: itemModels)
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
    
    func adaptItemsToItemModels(items: [Item]) -> [ItemModel] {
        
        var itemMods: [ItemModel] = []
        
        for item in items {
            if let itemMod = adaptItemToItemModel(itemToAdapt: item) {
                itemMods.append(itemMod)
            }
        }
        return itemMods
    }
    
    func adaptItemToItemModel(itemToAdapt: Item) -> ItemModel? {
        var itemModel: ItemModel? = nil
    
        itemModel?.name = itemToAdapt.itemName
        itemModel?.ownerOfItem = itemToAdapt.itemOwner
        itemModel?.quantityOfItem = Int16(itemToAdapt.itemQuantity)
        itemModel?.shoppingListId = itemToAdapt.shoppingList
        
        return itemModel
    }
    
    func shoppingList(at index: Int) -> ShoppingList? {
        
        if isIndexValid(index: index) {
            return shoppingLists[index]
        }
        return nil
    }
    
    func updateShoppingList(at index: Int, with: ShoppingList) {
        if shoppingList(at: index) != nil {
            self.shoppingLists[index] = with
        }
    }
    
    func deleteShoppingList(at index: Int) {
        if shoppingList(at: index) != nil {
            shoppingLists.remove(at: index)
        }
    }
    
    func addShoppingList(shoppingList: ShoppingList) {
        shoppingLists.append(shoppingList)
    }
}
