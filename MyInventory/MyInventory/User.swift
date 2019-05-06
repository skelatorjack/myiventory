//
//  User.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIImage
// Model Class


class User {
    private var itemList: [Item]
    private var coreDataInterface: CoreDataObject
    private var coreDataShoppingList: CoreDataShoppingList
    private var coreDataImageInterface: CoreDataImage
    private var shoppingLists: [ShoppingList]
    
    init(itemList: [Item] = [], appDel: AppDelegate, shoppingLists: [ShoppingList] = []) {
        self.itemList = itemList
        
        let managedContext =
            appDel.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        let shoppingListFetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ShoppingListModel")
        let imageFetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ImageData")
        
        let entity = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedContext)
        let shoppingListEntity = NSEntityDescription.entity(forEntityName: "ShoppingListModel", in: managedContext)
        let imageEntity = NSEntityDescription.entity(forEntityName: "ImageData", in: managedContext)
        self.coreDataInterface = CoreDataObject(appDel: appDel, managedContext: managedContext, fetchReq: fetchRequest, entity: entity!)
        
        self.coreDataShoppingList = CoreDataShoppingList(appDel: appDel, newManagedContext: managedContext, newFetchReq: shoppingListFetchRequest, newEntity: shoppingListEntity!)
        self.shoppingLists = shoppingLists
        self.coreDataImageInterface = CoreDataImage(appDel: appDel, managedContext: managedContext, fetchReq: imageFetchRequest, imageToSave: [], entity: imageEntity!)
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
        return itemList.firstIndex(of: itemToFind)
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
        guard let index = shoppingLists.firstIndex(where: { $0.getListName() == shoppingListName }) else {
            return nil
        }
        return index
    }
    
    func addItemsToShoppingLists(itemList: [Item], shoppingList: ShoppingList) -> ShoppingList {
        let newShoppingList: ShoppingList = ShoppingList(listName: shoppingList.getListName(), shoppingListId: shoppingList.getShoppingListId())
        
        for item in itemList {
           newShoppingList.addItemToKey(item: item)
        }
        
        return newShoppingList
    }
    
    func add(item: Item) {
        if coreDataInterface.saveItem(item: item) {
            print("Adding item \(item)")
            if item.isInventoryItem {
                itemList.append(item)
            }
        }
        
        if item.hasImage && item.itemImage != nil {
            coreDataImageInterface.saveImage(with: item, image: item.itemImage!)
        }
    }
    
    func delete(at index: Int) {
        guard let item = self.item(at: index) else {
            return
        }
        
        if item.hasImage {
            deleteItemWithImage(at: index)
        }
        if coreDataInterface.deleteItem(itemToDelete: item) {
            itemList.remove(at: index)
        }
    }
    
    private func deleteItemWithImage(at indec: Int) {
        if let item = self.item(at: indec) {
            coreDataImageInterface.deleteImage(with: item)
        }
    }
    func updateItem(at index: Int, with item: Item) {
        if let oldItem = self.item(at: index) {
            coreDataInterface.updateItem(oldItem: oldItem, newItem: item, indexOfUpdate: index, itemList: &itemList)
        }
    }
    
    func updateItem(at index: Int, with updatedItem: UpdatedItem) {
        guard let selectedItem = self.item(at: index) else {
            return
        }
    
        var didSaveImage: Bool = false
        let newItem = Item(updatedItem: updatedItem, item: selectedItem)
        
        if selectedItem.hasImage && hasImageChanged(item: selectedItem, image: updatedItem.itemImage) {
            coreDataImageInterface.updateItemImage(item: selectedItem, image: updatedItem.itemImage!)
            didSaveImage = true
        } else if selectedItem.hasImage && !updatedItem.hasImage {
            coreDataImageInterface.deleteImage(with: selectedItem)
            didSaveImage = true
        } else if !selectedItem.hasImage && updatedItem.hasImage {
            coreDataImageInterface.saveImage(with: selectedItem, image: updatedItem.itemImage!)
            didSaveImage = true
        }
        updateItem(at: index, with: newItem)
    }
    
    private func hasImageChanged(item: Item, image: UIImage? = nil) -> Bool {
        guard let itemImage = coreDataImageInterface.fetchImage(with: item), image != nil else {
            return false
        }
        return !itemImage.isEqual(to: image!)
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
            
                if var item = adaptItemModelToItem(itemModel: model) {
                    let image = fetchImage(with: item)
                    item.itemImage = image
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
        filterOutShoppingListItems(itemModelList: itemModels)
    }
    
    private func filterOutShoppingListItems(itemModelList: [ItemModel]) {
        let inventoryItems = itemModelList.filter({ $0.isInventoryItem })
        
        print("Adapting inventory items")
        adaptItemModelToItemList(itemModels: inventoryItems)
    }
    func fetchShoppingListItems() {
        var newShoppingLists: Array<ShoppingList> = Array()
        print("Size of shoppinglist is \(shoppingLists.count)")
        for shoppingList in shoppingLists {
            let shoppingListItemModels: [ItemModel] = coreDataInterface.fetchShoppingListItems(shoppingList: shoppingList)
            let shoppingListItems = adaptShoppingListItemModelToItem(itemModels: shoppingListItemModels)
            let newShoppingList = addItemsToShoppingLists(itemList: shoppingListItems, shoppingList: shoppingList)
            newShoppingLists.append(newShoppingList)
        }
        shoppingLists = newShoppingLists
    }
    
    func fetchShoppingLists() {
        let shoppingListModels: [ShoppingListModel] = coreDataShoppingList.fetchSavedData()
        adaptShoppingListModelToShoppingListList(shoppingListModels: shoppingListModels)
    }
    
    private func convertStringToType(type: String) -> ItemCategory {
        switch type {
        case "Food": return ItemCategory.Food
        case "Tech": return ItemCategory.Tech
        case "Cleaning": return ItemCategory.Cleaning
        case "Clothes" : return ItemCategory.Clothes
        case "Fashion" : return ItemCategory.Fashion
        case "Tools" : return ItemCategory.Tools
        case "Yard" : return ItemCategory.Yard
        default: return ItemCategory.Other
        }
    }
    func adaptItemModelToItem(itemModel: ItemModel) -> Item? {
        
        let quantity = Int(itemModel.quantityOfItem)
        var shoppingListId: UUID? = nil
        let category = convertStringToType(type: itemModel.itemCategory!)
        
        guard let name = itemModel.name,
            let owner = itemModel.ownerOfItem,
            let shoppingList = itemModel.shoppingListName,
            let shopName = itemModel.shopName,
            let itemIdAsString = itemModel.itemId else {
            return nil
        }
        if let shopListId = itemModel.shoppingListId, !shopListId.isEmpty {
            shoppingListId = UUID(uuidString: shopListId)
        }
        guard let itemId = UUID(uuidString: itemIdAsString) else {
            return nil
        }
        return Item(newName: name, newOwner: owner, newQuantity: quantity, newShoppingList: shoppingList, shopName: shopName, newCategory: category, newShoppingListID: shoppingListId, newItemId: itemId, hasImage: itemModel.hasImage, isInventoryItem: itemModel.isInventoryItem, newItemImage: nil)
    }
    
    func pullImageFromCoreData(uuid: UUID) -> UIImage? {
        return coreDataImageInterface.fetchImage(with: uuid)
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
            if var item = adaptItemModelToItem(itemModel: itemModel) {
                let image = fetchImage(with: item)
                item.itemImage = image
                items.append(item)
                print("Added \(item)")
            }
        }
        return items
    }
    
    func adaptShoppingListModelToShoppingList(shoppingListModel: ShoppingListModel) -> ShoppingList?  {
        let id = UUID(uuidString: shoppingListModel.shoppingListId!)
        guard let name = shoppingListModel.listName else {
                return nil
        }
        return ShoppingList(listName: name, shoppingListId: id)
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
            let shoppingListToDelete = shoppingLists[index]
            
            coreDataInterface.deleteShoppingListItems(shoppingList: shoppingListToDelete)
            coreDataShoppingList.deleteShoppingList(shoppingListToDelete: shoppingListToDelete)
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
        
        let shoppingListToUpdate = shoppingLists[index]
        
        print("Before updating list.")
        coreDataShoppingList.updateListName(shoppingList: shoppingListToUpdate, newShoppingListName: newShoppingListName)
        print("After updating list.")
        coreDataInterface.updateItemsOfChangedList(oldList: shoppingListToUpdate, newListName: newShoppingListName)
    }
    
    func addItemToShoppingList(index: Int, item: Item) {
        if isShoppingListIndexValid(index: index) {
            //shoppingLists[index].addItemToKey(item: item)
            if item.doesItemHaveImage() {
                saveImage(with: item, and: item.itemImage!)
            } else {
                coreDataInterface.saveItem(item: item)
            }
        }
    }
    
    func fetchImage(with item: Item) -> UIImage? {
        return coreDataImageInterface.fetchImage(with: item)
    }
    
    func saveImage(with item: Item, and image: UIImage) {
        coreDataImageInterface.saveImage(with: item, image: image)
        let result = coreDataInterface.saveItem(item: item)
        
        if result {
            print("Sucessfully saved \(item)")
        } else {
            print("Falied to save \(item)")
        }
    }
}
