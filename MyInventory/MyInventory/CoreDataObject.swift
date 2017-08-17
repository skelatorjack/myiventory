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
    
    init(appDel: AppDelegate, managedContext: NSManagedObjectContext, fetchReq: NSFetchRequest<NSManagedObject>, itemsToSave: [NSManagedObject] = []) {
        self.appDelegate = appDel
        self.managedContext = managedContext
        self.fetchRequest = fetchReq
        self.itemsToSave = itemsToSave
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
    
    func saveItem() {
        do {
            
        } catch {
            print("Could not save item \(error)")
        }
    }
    
    func deleteItem() {
        
    }
    
    func updateItem() {
        
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
