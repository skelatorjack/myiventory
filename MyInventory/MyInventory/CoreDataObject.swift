//
//  CoreDataObject.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/16/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import CoreData

enum CoreDateItemKeys: String {
    case isInventoryItem
    case quantityOfItem
    case itemCategory
    case name
    case ownerOfItem
    case shopName
    case shoppingListId
    case shoppingListName
    case hasImage
    case itemId
}

class CoreDataObject {
    
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<NSManagedObject>
    private var itemsToSave: [NSManagedObject]
    private let entity: NSEntityDescription
    private var numberOfItemsPersisted: Int = 0
    
    init(appDel: AppDelegate, managedContext: NSManagedObjectContext, fetchReq: NSFetchRequest<NSManagedObject>, itemsToSave: [NSManagedObject] = [], entity: NSEntityDescription) {
        self.appDelegate = appDel
        self.managedContext = managedContext
        self.fetchRequest = fetchReq
        self.itemsToSave = itemsToSave
        self.entity = entity
    }
    
    private func setNumberOfItemsPersisted(count: Int) {
        numberOfItemsPersisted = count
    }
    
    private func increaseNumberOfItemsPersisted() {
        numberOfItemsPersisted += 1
    }
    
    private func decreaseNumberOfItemsPersisted() {
        numberOfItemsPersisted -= 1
    }
    
    func getNumberOfItemsPersisted() -> Int {
        return numberOfItemsPersisted
    }
    
    func fetchSavedData() -> [ItemModel] {
        var items: [NSManagedObject] = []
        let searchCriteria: [NSPredicate] = []
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            items = try managedContext.fetch(fetchRequest)
            setNumberOfItemsPersisted(count: items.count)
        } catch {
            print("Failed fetch saved data \(error)")
        }
        
        return items as! [ItemModel]
    }
    
    func fetchInventoryItems() -> [ItemModel] {
        var items: [NSManagedObject] = []
        let searchCriteria = getInventoryItems()
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            items = try managedContext.fetch(fetchRequest)
            setNumberOfItemsPersisted(count: items.count)
        } catch {
            print("Failed to fetch inventory items \(error)")
        }
        
        guard let itemModels = items as? [ItemModel] else {
            return []
        }
        return itemModels
    }
    
    func fetchShoppingListItems(shoppingList: ShoppingList) -> [ItemModel] {
        var shoppingListItems: [NSManagedObject] = []
        let shoppingListItemSearchCriteria: [NSPredicate] = getShoppingListItemCriteria(shoppingListId: shoppingList.getShoppingListId()!)
    
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: shoppingListItemSearchCriteria)
        
        do {
            shoppingListItems = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch save data")
        }
        
        return shoppingListItems as! [ItemModel]
    }
    
    func saveItem(item: Item) -> Bool {
        let itemToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        updateManagedObject(managedObject: itemToSave, with: item)
        
        do {
            itemsToSave.append(itemToSave)
            increaseNumberOfItemsPersisted()
            try managedContext.save()
            return true
        } catch {
            print("Could not save item \(error)")
            return false
        }
    }
    
    func deleteItem(itemToDelete: Item) -> Bool {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: itemToDelete)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for itemToDel in result {
                    managedContext.delete(itemToDel)
                    decreaseNumberOfItemsPersisted()
                }
                try managedContext.save()
                return true
            }
            return false
        } catch {
            print("Failed to delete item \(error)")
            return false
        }
    }
    
    func deleteShoppingListItems(shoppingList: ShoppingList) {
        let searchCriteria: [NSPredicate] = getShoppingListSearchCriteria(shoppingList: shoppingList)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for itemToDelete in result {
                    managedContext.delete(itemToDelete)
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to delete items")
        }
    }
    
    func deleteShoppingListItem(itemToDelete: Item) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: itemToDelete)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for itemToDel in result {
                    managedContext.delete(itemToDel)
                    decreaseNumberOfItemsPersisted()
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to delete item \(error)")
        }
    }
    
    func updateItem(oldItem: Item, newItem: Item, indexOfUpdate: Int = -1, itemList: inout [Item]) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: oldItem)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let searchedForItems = try managedContext.fetch(fetchRequest)
            guard let firstItem = searchedForItems.first else { return }
            updateManagedObject(managedObject: firstItem, with: newItem)
            try managedContext.save()
            
            if indexOfUpdate != -1 {
                itemList[indexOfUpdate] = newItem
            }
        } catch {
            print("Couldn't update item \(error)")
        }
    }
    
    func updateItemsOfChangedList(oldList: ShoppingList, newListName: String) {
        let searchCriteria: [NSPredicate] = getShoppingListSearchCriteria(shoppingList: oldList)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        let newShoppingList: ShoppingList = ShoppingList(listName: newListName, shoppingListId: oldList.getShoppingListId())
        
        do {
            let searchedForItems = try managedContext.fetch(fetchRequest)
            
            for item in searchedForItems {
                updateManagedObjectShoppingListName(managedObject: item, shoppingList: newShoppingList)
            }
            try managedContext.save()
        } catch {
            print("Couldn't update list item")
        }
    }
    private func updateManagedObject(managedObject: NSManagedObject, with item: Item) {
        print("Raw value of name key \(CoreDateItemKeys.name.rawValue)")
        managedObject.setValue(item.itemName, forKey: CoreDateItemKeys.name.rawValue)
        managedObject.setValue(item.itemOwner, forKey: CoreDateItemKeys.ownerOfItem.rawValue)
        managedObject.setValue(item.itemQuantity, forKey: CoreDateItemKeys.quantityOfItem.rawValue)
        managedObject.setValue(item.shoppingList, forKey: CoreDateItemKeys.shoppingListName.rawValue)
        managedObject.setValue(item.shopName, forKey: CoreDateItemKeys.shopName.rawValue)
        managedObject.setValue(item.itemCategory.rawValue, forKey: CoreDateItemKeys.itemCategory.rawValue)
        managedObject.setValue(item.isInventoryItem, forKey: CoreDateItemKeys.isInventoryItem.rawValue)
        managedObject.setValue(item.hasImage, forKey: CoreDateItemKeys.hasImage.rawValue)
        managedObject.setValue(item.itemId.uuidString, forKey: CoreDateItemKeys.itemId.rawValue)
        
        var idString: String = ""
        
        if !item.isInventoryItem, let uuid = item.shoppingListID {
            idString = uuid.uuidString
        }
        managedObject.setValue(idString, forKey: CoreDateItemKeys.shoppingListId.rawValue)
    }
    
    private func updateManagedObjectShoppingListName(managedObject: NSManagedObject, shoppingList: ShoppingList) {
        managedObject.setValue(shoppingList.getListName(), forKey: "shoppingListName")
    }
    
    private func getSearchCriteria(item: Item) -> [NSPredicate] {
        let searchCriteria: [NSPredicate] = [
            NSPredicate(format: "itemId == %@", item.itemId.uuidString),
        ]
        
        return searchCriteria
    }
    
    private func getInventoryItems() -> [NSPredicate] {
//        return [NSPredicate(format: "isInventoryItem == %@", "true"),
//                NSPredicate(format: "shoppingListId == %@", "")]
        return [NSPredicate(format: "isInventoryItem == %@", "true")]
    }
    
    private func getShoppingListSearchCriteria(shoppingList: ShoppingList) -> [NSPredicate] {
        return [
            NSPredicate(format: "shoppingListName == %@", shoppingList.getListName()),
            NSPredicate(format: "shoppingListId == %@", shoppingList.convertUUIDToString()),
        ]
    }
    
    private func getInventoryItemSearchCriteria() -> [NSPredicate] {
        let searchCriteria: [NSPredicate] = [
            NSPredicate(format: "shoppingListId == %@", "")
        ]
        return searchCriteria
    }
    
    func getShoppingListItemCriteria(shoppingListId: UUID) -> [NSPredicate] {
        let shoppingListSearchCriteria: [NSPredicate] = [
            NSPredicate(format: "shoppingListId == %@", shoppingListId.uuidString),
        ]
        
        return shoppingListSearchCriteria
    }

}
