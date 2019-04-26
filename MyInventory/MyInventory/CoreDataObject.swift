//
//  CoreDataObject.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/16/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import CoreData

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
        //let searchCriteria: [NSPredicate] = getInventoryItems()
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
    
    func saveItem(item: Item, itemList: inout [Item]) {
        let itemToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        updateManagedObject(managedObject: itemToSave, with: item)
        
        do {
            itemsToSave.append(itemToSave)
            increaseNumberOfItemsPersisted()
            try managedContext.save()
            itemList.append(item)
        } catch {
            print("Could not save item \(error)")
        }
    }
    
    func deleteItem(itemToDelete: Item, indexToDelete: Int, itemList: inout [Item]) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: itemToDelete)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for itemToDel in result {
                    managedContext.delete(itemToDel)
                    decreaseNumberOfItemsPersisted()
                }
                try managedContext.save()
                itemList.remove(at: indexToDelete)
            }
        } catch {
            print("Failed to delete item \(error)")
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
        managedObject.setValue(item.itemName, forKey: "name")
        managedObject.setValue(item.itemOwner, forKey: "ownerOfItem")
        managedObject.setValue(item.itemQuantity, forKey: "quantityOfItem")
        managedObject.setValue(item.shoppingList, forKey: "shoppingListName")
        managedObject.setValue(item.shopName, forKey: "shopName")
        managedObject.setValue(item.itemCategory.rawValue, forKey: "itemCategory")
        
        if let shoppingListId = item.shoppingListID {
            let idString = shoppingListId.uuidString
            managedObject.setValue(idString, forKey: "shoppingListId")
        } else {
            managedObject.setValue("None", forKey: "shoppingListId")
        }
    }
    
    private func updateManagedObjectShoppingListName(managedObject: NSManagedObject, shoppingList: ShoppingList) {
        managedObject.setValue(shoppingList.getListName(), forKey: "shoppingListName")
    }
    
    private func getSearchCriteria(item: Item) -> [NSPredicate] {
        var searchCriteria: [NSPredicate] = [
            NSPredicate(format: "name == %@", item.itemName),
            NSPredicate(format: "ownerOfItem == %@", item.itemOwner),
            NSPredicate(format: "quantityOfItem == %@", String(item.itemQuantity)),
            NSPredicate(format: "shoppingListName == %@", item.shoppingList),
            NSPredicate(format: "shopName == %@", item.shopName),
        ]
        if item.isInventoryItem {
            searchCriteria.append(NSPredicate(format: "shoppingListId == %@", "None"))
        } else {
            searchCriteria.append(NSPredicate(format: "shoppingListId == %@", item.shoppingListID!.uuidString))
        }
        
        return searchCriteria
    }
    
    private func getInventoryItems() -> [NSPredicate] {
        return [NSPredicate(format: "shoppingListId == %@", "None")]
    }
    
    private func getShoppingListSearchCriteria(shoppingList: ShoppingList) -> [NSPredicate] {
        return [NSPredicate(format: "shoppingListName == %@", shoppingList.getListName()),
                NSPredicate(format: "shoppingListId == %@", shoppingList.convertUUIDToString())
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
            NSPredicate(format: "shoppingListId == %@", shoppingListId.uuidString)
        ]
        
        return shoppingListSearchCriteria
    }

}
