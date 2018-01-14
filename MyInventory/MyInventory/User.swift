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
    private var coreDataShoppingList: CoreDataShoppingList
    private var shoppingLists: [ShoppingList]
    
    init(itemList: [Item] = [], appDel: AppDelegate, shoppingLists: [ShoppingList] = []) {
        self.itemList = itemList
        
        let managedContext =
            appDel.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        let shoppingListFetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ShoppingListModel")
        
        let entity = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedContext)
        let shoppingListEntity = NSEntityDescription.entity(forEntityName: "ShoppingListModel", in: managedContext)
        
        self.coreDataInterface = CoreDataObject(appDel: appDel, managedContext: managedContext, fetchReq: fetchRequest, entity: entity!)
        
        self.coreDataShoppingList = CoreDataShoppingList(appDel: appDel, newManagedContext: managedContext, newFetchReq: shoppingListFetchRequest, newEntity: shoppingListEntity!)
        self.shoppingLists = shoppingLists

    }
    
    private func isIndexValid(index: Int) -> Bool {
        if index >= itemList.count || index < 0 {
            return false
        }
        return true
    }
    
    private func isShoppingListIndexValid(index: Int) -> Bool {
        return index < shoppingLists.count || index > 0
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
    
    private func doesShoppingListContain(shopListName: String) -> Bool {
        for shoppingList in shoppingLists {
            if shoppingList.getListName() == shopListName {
                return true
            }
        }
        return false
    }

    func setUpShoppingLists(shoppingListItems: [Item]) {
        for item in shoppingListItems {
            if doesShoppingListContain(shopListName: item.shoppingList) {
                guard let INDEX = getIndexOfShoppingList(shoppingListName: item.shoppingList) else {
                    return
                }
                shoppingLists[INDEX].addItemToKey(item: item)
            }
        }
    }
    
    private func getIndexOfShoppingList(shoppingListName: String) -> Int? {
        guard let index = shoppingLists.index(where: { $0.getListName() == shoppingListName }) else {
            return nil
        }
        return index
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
    
    func adaptShoppingListModelToShoppingListList(shoppingListModels: [ShoppingListModel]) {
        var shoppingListsList: [ShoppingList] = []
        
        if shoppingListsList.isEmpty, !shoppingListModels.isEmpty {
            for model in shoppingListModels {
                if let shoppingList = adaptShoppingListModelToShoppingList(shoppingListModel: model) {
                    shoppingListsList.append(shoppingList)
                }
            }
            shoppingLists = shoppingListsList
        }
    }
    
    func setUpUser() {
        fetchSaveDataFromCoreData()
    }
    
    private func fetchSaveDataFromCoreData() {
        fetchInventorySaveData()
        fetchShoppingLists()
        fetchShoppingListItems()
    }
    func fetchInventorySaveData() {
        let itemModels: [ItemModel] = coreDataInterface.fetchSavedData()
        let items = adaptShoppingListItemModelToItem(itemModels: itemModels)
    }
    
    private func filterOutShoppingListItems(itemList: [Item]) {
        
    }
    func fetchShoppingListItems() {
        let shoppingListItemModels: [ItemModel] = coreDataInterface.fetchShoppingListItems()
        setUpShoppingLists(shoppingListItems: adaptShoppingListItemModelToItem(itemModels: shoppingListItemModels))
    }
    
    func fetchShoppingLists() {
        let shoppingListModels: [ShoppingListModel] = coreDataShoppingList.fetchSavedData()
        adaptShoppingListModelToShoppingListList(shoppingListModels: shoppingListModels)
    }
    
    func adaptItemModelToItem(itemModel: ItemModel) -> Item? {
        
        let quant = Int(itemModel.quantityOfItem)
        
        guard let name = itemModel.name,
            let owner = itemModel.ownerOfItem,
            let shoppingList = itemModel.shoppingListId,
            let shopName = itemModel.shopName else {
                
                return nil
        }
        
        return Item(newName: name, newOwner: owner, newQuantity: quant, newShoppingList: shoppingList, shopName: shopName)
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
    
    func adaptShoppingListItemModelToItem(itemModels: [ItemModel]) -> [Item] {
        var items: [Item] = []
        
        for itemModel in itemModels {
            if let ITEM = adaptItemModelToItem(itemModel: itemModel) {
                items.append(ITEM)
            }
        }
        return items
    }
    
    func adaptShoppingListModelToShoppingList(shoppingListModel: ShoppingListModel) -> ShoppingList?  {
        guard let name = shoppingListModel.listName else {
                return nil
        }
        return ShoppingList(listName: name)
    }
    func adaptShoppingListsToShoppingListModels(shoppingLists: [ShoppingList]) -> [ShoppingListModel] {
        var shoppingListModels: [ShoppingListModel] = []
        
        for shoppingList in shoppingLists {
            if let shopListMod = adaptShoppingListToShoppingListModel(shoppingListToAdapt: shoppingList){
                shoppingListModels.append(shopListMod)
            }
        }
        
        return shoppingListModels
    }
    
    func adaptShoppingListToShoppingListModel(shoppingListToAdapt: ShoppingList) -> ShoppingListModel? {
        let shoppingListModel: ShoppingListModel? = nil
        
        shoppingListModel?.listName = shoppingListToAdapt.getListName()
        shoppingListModel?.numberOfItemsInList = Int16(shoppingListToAdapt.getTotalNumberOfItemsInList())
        
        return shoppingListModel
    }
    
    func adaptItemToItemModel(itemToAdapt: Item) -> ItemModel? {
        let itemModel: ItemModel? = nil
    
        itemModel?.name = itemToAdapt.itemName
        itemModel?.ownerOfItem = itemToAdapt.itemOwner
        itemModel?.quantityOfItem = Int16(itemToAdapt.itemQuantity)
        itemModel?.shoppingListId = itemToAdapt.shoppingList
        
        return itemModel
    }
    
    func shoppingList(at index: Int) -> ShoppingList? {
        if isShoppingListIndexValid(index: index) {
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
    
    func deleteItemFromShoppingList(itemToDelete: Item) {
        coreDataInterface.deleteShoppingListItem(itemToDelete: itemToDelete)
    }
    
    func addShoppingList(shoppingList: ShoppingList) {
        shoppingLists.append(shoppingList)
        coreDataShoppingList.saveShoppingList(shoppingList: shoppingList)
    }
    
    func updateItemInShoppingList(oldItem: Item, newItem: Item) {
        coreDataInterface.updateItem(oldItem: oldItem, newItem: newItem, itemList: &itemList)
    }
    
    func updateShoppingListName(newShoppingListName: String, index: Int) {
        print("Updating shopping list \(index)\n")
        print("Before: \(shoppingLists[index].getListName())\n")
        print("After: \(newShoppingListName)\n")
    }
    
    func addItemToShoppingList(index: Int, item: Item) {
        if isShoppingListIndexValid(index: index) {
            // shoppingLists[index].addItemToKey(item: item)
            add(item: item)
        }
    }
}
