//
//  CoreDataShoppingList.swift
//  MyInventory
//
//  Created by Jack Pettit on 1/9/18.
//  Copyright © 2018 jpettit. All rights reserved.
//

import Foundation
import CoreData

class CoreDataShoppingList {
    
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<NSManagedObject>
    private let entity: NSEntityDescription
    private var shoppingListsToSave: [NSManagedObject]
    
    init(appDel: AppDelegate, newManagedContext: NSManagedObjectContext, newFetchReq: NSFetchRequest<NSManagedObject>, newEntity: NSEntityDescription, newListToSave: [NSManagedObject] = []) {
        appDelegate = appDel
        managedContext = newManagedContext
        fetchRequest = newFetchReq
        entity = newEntity
        shoppingListsToSave = newListToSave
    }
    
    func fetchSavedData() -> [ShoppingListModel] {
        var listOfShoppingLists: [NSManagedObject] = []
        
        do {
            listOfShoppingLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to retrieve saved shopping lists")
        }
        
        return listOfShoppingLists as! [ShoppingListModel]
    }
    
    private func getSearchCriteria(shoppingList: ShoppingList) -> [NSPredicate] {
        let searchCriteria: [NSPredicate] = [
            NSPredicate(format: "listName == %@", shoppingList.getListName()),
            NSPredicate(format: "shoppingListId == %@", shoppingList.convertUUIDToString())
        ]
        
        return searchCriteria
    }
    
    func saveShoppingList(shoppingList: ShoppingList) {
        let shoppingListToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        updateCoreDataShoppingList(coreDataList: shoppingListToSave, with: shoppingList)
        
        do {
            shoppingListsToSave.append(shoppingListToSave)
            try managedContext.save()
        } catch {
            print("Couldn't save shopping list")
        }
    }
    
    private func updateCoreDataShoppingList(coreDataList: NSManagedObject, with shoppingList: ShoppingList) {
        coreDataList.setValue(shoppingList.getListName(), forKey: "listName")
        coreDataList.setValue(shoppingList.getTotalNumberOfItemsInList(), forKey: "numberOfItemsInList")
        coreDataList.setValue(shoppingList.getShoppingListId(), forKey: "shoppingListId")
    }
    
    private func updateCoreDataShoppingListName(coreDataList: NSManagedObject, newListName: String) {
        coreDataList.setValue(newListName, forKey: "listName")
    }
    
    func updateList(oldShoppingList: ShoppingList, newShoppingList: ShoppingList) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(shoppingList: oldShoppingList)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let searchedShoppingLists = try managedContext.fetch(fetchRequest)
            guard let firstList = searchedShoppingLists.first else { return }
            updateCoreDataShoppingList(coreDataList: firstList, with: newShoppingList)
            try managedContext.save()
        } catch {
            print("Could not update list \(error)")
        }
    }
    
    func updateListName(shoppingList: ShoppingList, newShoppingListName: String) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(shoppingList: shoppingList)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let searchedShoppingLists = try managedContext.fetch(fetchRequest)
            guard let firstList = searchedShoppingLists.first else { return }
            updateCoreDataShoppingListName(coreDataList: firstList, newListName: newShoppingListName)
            try managedContext.save()
        } catch {
            print("Could not update list name")
        }
    }
    
    func deleteShoppingList(shoppingListToDelete: ShoppingList) {
        let searchCriteria: [NSPredicate] = getSearchCriteria(shoppingList: shoppingListToDelete)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for shoppingListToDel in result {
                    managedContext.delete(shoppingListToDel)
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to delete shoppingList")
        }
    }
}
