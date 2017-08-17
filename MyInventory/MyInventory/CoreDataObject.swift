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
    
    init(appDel: AppDelegate, managedContext: NSManagedObjectContext, fetchReq: NSFetchRequest<NSManagedObject>, itemsToSave: [NSManagedObject] = [], entity: NSEntityDescription) {
        self.appDelegate = appDel
        self.managedContext = managedContext
        self.fetchRequest = fetchReq
        self.itemsToSave = itemsToSave
        self.entity = entity
    }
    
    func fetchSavedData() -> [ItemModel] {
        var items: [NSManagedObject] = []
        
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed fetch saved data \(error)")
        }
        
        return items as! [ItemModel]
    }
    
    func saveItem(item: Item) {
        let itemToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        updateManagedObject(managedObject: itemToSave, with: item)
        
        do {
            itemsToSave.append(itemToSave)
            try managedContext.save()
        } catch {
            print("Could not save item \(error)")
        }
    }
    
    func deleteItem(itemToDelete: Item) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: itemToDelete)

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for itemToDel in result {
                    managedContext.delete(itemToDel)
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to delete item \(error)")
        }
    }
    
    func updateItem(oldItem: Item, newItem: Item) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(item: oldItem)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let searchedForItems = try managedContext.fetch(fetchRequest)
            guard let firstItem = searchedForItems.first else { return }
            updateManagedObject(managedObject: firstItem, with: newItem)
            try managedContext.save()
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

}
