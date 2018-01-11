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
        
        do {
            items = try managedContext.fetch(fetchRequest)
            setNumberOfItemsPersisted(count: items.count)
        } catch {
            print("Failed fetch saved data \(error)")
        }
        
        return items as! [ItemModel]
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
    
    func updateItem(oldItem: Item, newItem: Item, indexOfUpdate: Int, itemList: inout [Item]) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: oldItem)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let searchedForItems = try managedContext.fetch(fetchRequest)
            guard let firstItem = searchedForItems.first else { return }
            updateManagedObject(managedObject: firstItem, with: newItem)
            try managedContext.save()
            itemList[indexOfUpdate] = newItem
        } catch {
            print("Couldn't update item \(error)")
        }
    }
    
    private func updateManagedObject(managedObject: NSManagedObject, with item: Item) {
        managedObject.setValue(item.itemName, forKey: "name")
        managedObject.setValue(item.itemOwner, forKey: "ownerOfItem")
        managedObject.setValue(item.itemQuantity, forKey: "quantityOfItem")
        managedObject.setValue(item.shoppingList, forKey: "shoppingListId")
    }
    
    private func getSearchCriteria(item: Item) -> [NSPredicate] {
        let searchCriteria: [NSPredicate] = [
            NSPredicate(format: "name == %@", item.itemName),
            NSPredicate(format: "ownerOfItem == %@", item.itemOwner),
            NSPredicate(format: "quantityOfItem == %@", String(item.itemQuantity)),
            NSPredicate(format: "shoppingListId == %@", item.shoppingList)
        ]
        
        return searchCriteria
    }
    
    func getShoppingListItemCriteria() -> [NSPredicate] {
        let shoppingListSearchCriteria: [NSPredicate] = [
            NSPredicate(format: "shoppingListId != %@", "")
        ]
        
        return shoppingListSearchCriteria
    }

}
