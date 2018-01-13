//
//  ViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/14/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import UIKit
import CoreData



class ItemListViewController: UITableViewController, AddItemDelegate, UpdateItemDelegate, UpdateUserWithShoppingList {

    var user: User = User(appDel: (UIApplication.shared.delegate as? AppDelegate)!)
    
    var items: [NSManagedObject] = []
    
    private let UPDATEITEMID: String = "updateItem"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.rowHeight = 64
        user.setUpUser()
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
            
            print("Updating \(String(describing: user.item(at: index)))")
                updateItemDest.setValues(name: item.itemName, quantity: String(item.itemQuantity), owner: item.itemOwner, index: index, list: item.shoppingList)
                updateItemDest.delegate = self
        }
        else if let shoppingListVC = segue.destination as? ShoppingListsViewController {
            
            shoppingListVC.setShoppingLists(userShoppingLists: user.getShoppingLists())
            
            shoppingListVC.delegate = self
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
        }
        del.backgroundColor = UIColor.red
        return [del]
    }
    
    // For updating an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: UPDATEITEMID, sender: indexPath.row)
    }
    
    private func refreshTable() {
        tableView.reloadData()
    }
    
    func addItem(item: Item) {
        user.add(item: item)
        refreshTable()
    }
    
    func updateItem(item: Item, at index: Int) {
        user.updateItem(at: index, with: item)
        refreshTable()
    }
    
    func updateItem(oldItem: Item, newItem: Item, indexOfUpdate: Int, listIndex: Int) {
        print("Updating \(oldItem) at index \(indexOfUpdate) with \(newItem) in shopping list \(listIndex)")
        user.updateItemInShoppingList(oldItem: oldItem, newItem: newItem)
    }
    
    func updateUser(with shoppingList: ShoppingList, at index: Int, update: String) {
        if update == "addItem" {
            print("Need to figure out what item to add.")
        }
        else if update == "deleteItemFromShoppingList" {
            print("Need to delete item from shopping list")
        }
    }
    
    func add(shoppingList: ShoppingList) {
        user.addShoppingList(shoppingList: shoppingList)
    }
    
    func remove(shoppingList: ShoppingList, index: Int) {
        user.deleteShoppingList(at: index)
    }
    
    func addItem(to list: Int, item: Item) {
        print("Adding item to list \(list)")
        user.addItemToShoppingList(index: list, item: item)
    }
    
    func update(shoppingListName: String, at index: Int) {
        print("Updating shopping list \(index) with \(shoppingListName)")
    }
    
    func removeItemFromShoppingList(listIndex: Int, itemToDelete: Item) {
        print("Need to delete item from shopping list")
        user.deleteItemFromShoppingList(itemToDelete: itemToDelete)
    }
    private func deleteItemFromCoreData(at index: Int) {
        user.delete(at: index)
        refreshTable()
    }
}
