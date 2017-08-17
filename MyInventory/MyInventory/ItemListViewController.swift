//
//  ViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/14/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UITableViewController, AddItemDelegate, UpdateItemDelegate {

    var user: User = User()
    
    var items: [NSManagedObject] = []
    
    private let UPDATEITEMID: String = "updateItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.rowHeight = 64
        fetchDataFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addItemdest = segue.destination as? AddItemViewController {
            addItemdest.delegate = self
        }
        else if let updateItemDest = segue.destination as? UpdateItemViewController,
                let index = sender as? Int,
                segue.identifier == UPDATEITEMID,
                let item = user.item(at: index) {
            
            print("Updating \(user.item(at: index))")
            updateItemDest.setValues(name: item.itemName, quantity: String(item.itemQuantity), owner: item.itemOwner, index: index)
            updateItemDest.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.getItemCount()
    }
    
    // Decorate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemTableCell
        else { return UITableViewCell() }
        
        
        
        let item: Item? = user.item(at: indexPath.row)
            
        cell.decorate(with: item)
        
        return cell
    }
    
    // For table row actions
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let del = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            print("Deleting item at index \(index.row)")
            self.deleteItemFromCoreData(at: index.row)
            self.refreshTable()
        }
        del.backgroundColor = UIColor.red
        return [del]
    }
    
    // For updating an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: UPDATEITEMID, sender: indexPath.row)
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
    
    func addItem(item: Item) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ItemModel", in: managedContext) else {
            return
        }
        
        let itemToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        
        updateManagedObject(managedObject: itemToSave, with: item)
        
        do {
            try managedContext.save()
            items.append(itemToSave)
            user.add(item: item)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        refreshTable()
    }
    
    func fetchDataFromCoreData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        
        do {
            items = try managedContext.fetch(fetchRequest)
            user.adaptItemModelToItemList(itemModels: items as! [ItemModel])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateItem(item: Item, at index: Int) {
        
        var searchCriteria: [NSPredicate] = []
        
        guard let itemToUpdate: Item = user.item(at: index) else { return }
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        searchCriteria = getSearchCriteriaForUpdating(itemToUpdate: itemToUpdate)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        
        do {
            let searchedForItems = try managedContext.fetch(fetchRequest)
            updateManagedObject(managedObject: searchedForItems.first!, with: item)
            try managedContext.save()
            user.updateItem(at: index, with: item)
        } catch {
            print(error)
        }
        
        refreshTable()
    }
    
    private func deleteItemFromCoreData(at index: Int) {
        var searchCriteria: [NSPredicate] = []
        
        guard let itemToDelete: Item = user.item(at: index) else { return }
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        let managedContext: NSManagedObjectContext = appDel.persistentContainer.viewContext
        searchCriteria = getSearchCriteriaForUpdating(itemToUpdate: itemToDelete)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                
                for itemToDel in result {
                    managedContext.delete(itemToDel)
                }
                try managedContext.save()
                user.delete(at: index)
            }
        } catch {
            print(error)
        }
        
    }
    private func getSearchCriteriaForUpdating(itemToUpdate: Item) -> [NSPredicate] {
        let searchCriteria: [NSPredicate] = [
            NSPredicate(format: "name == %@", itemToUpdate.itemName),
            NSPredicate(format: "ownerOfItem == %@", itemToUpdate.itemOwner),
            NSPredicate(format: "quantityOfItem == %@", String(itemToUpdate.itemQuantity)),
            NSPredicate(format: "shoppingListId == %@", itemToUpdate.shoppingList)
        ]
        
        return searchCriteria
    }
    
    private func updateManagedObject(managedObject: NSManagedObject, with item: Item) {
        managedObject.setValue(item.itemName, forKey: "name")
        managedObject.setValue(item.itemOwner, forKey: "ownerOfItem")
        managedObject.setValue(item.itemQuantity, forKey: "quantityOfItem")
        managedObject.setValue(item.shoppingList, forKey: "shoppingListId")
    }
}
