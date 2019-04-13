//
//  ShoppingListsViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateUserWithShoppingList: class {
    func updateUser(with shoppingList: ShoppingList, at index: Int, update: String)
    func add(shoppingList: ShoppingList)
    func remove(shoppingList: ShoppingList, index: Int)
    func removeItemFromShoppingList(listIndex: Int, itemToDelete: Item)
    func addItem(to list: Int, item: Item)
    func update(shoppingListName: String, at index: Int)
    func updateItem(oldItem: Item, newItem: Item, indexOfUpdate: Int, listIndex: Int)
}

enum UpdateShoppingListCase {
    case AddShopList
    case AddItemToShopList
    case DeleteItemFromShopList
    case UpdateItemFromShopList
    case DeleteShopList
    case UpdateListName
}

class ShoppingListsViewController: UITableViewController, AddShoppingList, UpdateShoppingList, AddItemToList, UpdateShoppingListName {
    
    private var shoppingLists: [ShoppingList] = []
    private var shoppingListNames: [String] = []
    
    private var indexOfShoppingList: Int = -1
    
    weak var delegate: UpdateUserWithShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShoppingListNames()
    }
    
    func setShoppingLists(userShoppingLists: [ShoppingList]) {
        shoppingLists = userShoppingLists
    }
    
    func setShoppingListNames() {
        for shoppingList in shoppingLists {
            addShoppingListName(newName: shoppingList.getListName())
        }
    }
    
    private func addShoppingListName(newName: String) {
        shoppingListNames.append(newName)
    }
    
    private func removeShoppingListName(at index: Int) {
        shoppingListNames.remove(at: index)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let addShopDest = segue.destination as? AddShoppingListViewController {
            addShopDest.delegate = self
        }
        else if let shopListDetail = segue.destination as? ShoppingListDetailViewController,
            segue.identifier == "editShoppingList",
            let indexOfList = sender as? Int {
            indexOfShoppingList = indexOfList
            
            shopListDetail.setList(list: shoppingLists[indexOfList])
            shopListDetail.setShoppingListNames(newList: shoppingListNames)
            
            shopListDetail.delegate = self
        }
        else if let updateListName = segue.destination as? UpdateListNameViewController,
            segue.identifier == "updateListName" {
            updateListName.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as? ShoppingListTableCell
            else { return UITableViewCell() }
        
        let shoppingList: ShoppingList? = shoppingLists[indexPath.row]
        
        if shoppingList != nil {
            cell.decorate(with: shoppingList!)
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editShoppingList", sender: indexPath.row)
    }
    
    // For table row actions such as delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let del = UITableViewRowAction(style: .destructive, title: "Delete List") { action, index in
            print("Deleting list at index \(index.row)")
            self.indexOfShoppingList = index.row
            self.delegate?.remove(shoppingList: self.shoppingLists[self.indexOfShoppingList], index: self.indexOfShoppingList)
            self.shoppingLists.remove(at: index.row)
            self.removeShoppingListName(at: index.row)
            self.reloadTable()
        }
        let updateListName = UITableViewRowAction(style: .normal, title: "Update List Name") { action, index in
            print("Updating list name at index \(index.row)")
            self.indexOfShoppingList = index.row
            self.performSegue(withIdentifier: "updateListName", sender: index.row)
        }
        del.backgroundColor = UIColor.red
        updateListName.backgroundColor = UIColor.orange
        
        return [del, updateListName]
    }
    
    func add(shoppingListName: String) {
        
        let newShoppingList: ShoppingList = ShoppingList(listName: shoppingListName, shoppingListId: UUID())
        
        shoppingLists.append(newShoppingList)
        shoppingListNames.append(shoppingListName)
        delegate?.add(shoppingList: newShoppingList)
        reloadTable()
    }
    
    func add(item: Item) {
        delegate?.addItem(to: indexOfShoppingList, item: item)
    }
    
    func addItemToShoppingList(item: Item) {
        add(item: item)
        reloadTable()
    }
    
    func update(shoppingListName: String) {
        delegate?.update(shoppingListName: shoppingListName, at: indexOfShoppingList)
        shoppingLists[indexOfShoppingList].setListName(name: shoppingListName)
        shoppingListNames[indexOfShoppingList] = shoppingLists[indexOfShoppingList].getListName()
        shoppingLists[indexOfShoppingList].updateItemsInShoppingList()
        reloadTable()
    }
    
    func deleteItemFromList(key: String, index: Int) {
        let SHOP_LIST: ShoppingList = shoppingLists[indexOfShoppingList]
        
        guard let DELETE_ITEM: Item = SHOP_LIST.getValue(key: key, index: index) else {
            return
        }
        delegate?.removeItemFromShoppingList(listIndex: indexOfShoppingList, itemToDelete: DELETE_ITEM)
    }
    
    func updateItemFromList(key: String, index: Int, newItem: Item) {
        let SHOP_LIST = shoppingLists[indexOfShoppingList]
        
        guard let UPDATE_ITEM = SHOP_LIST.getValue(key: key, index: index) else {
            return
        }
        
        delegate?.updateItem(oldItem: UPDATE_ITEM, newItem: newItem, indexOfUpdate: index, listIndex: indexOfShoppingList)
        
    }
    
    func move(item: Item, to newShoppingList: String, oldItem: Item, indexOfMovedItem: Int) {
        delegate?.updateItem(oldItem: oldItem, newItem: item, indexOfUpdate: indexOfMovedItem, listIndex: indexOfShoppingList)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}
