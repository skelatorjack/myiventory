//
//  ShoppingListDetailViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateShoppingList: class {
    func deleteItemFromList(key: String, index: Int)
    func updateItemFromList(key: String, index: Int, newItem: Item)
    func move(item: Item, to newShoppingList: String, oldItem: Item, indexOfMovedItem: Int)
    func addItemToShoppingList(item: Item)
}

class ShoppingListDetailViewController: UITableViewController, AddItemToList, UpdateItemInShoppingListDelegate, ChangeItemShoppingListDelegate {
    
    private var shoppingListToDisplay: ShoppingList = ShoppingList()
    private var shopNames: [String] = []
    private var shoppingListNames: [String] = []
    
    private var shopListName: String = ""
    
    private var indexOfUpdatedItem: Int = -1
    private var indexOfDeletedItem: Int = -1
    private var indexOfMovedItem: Int = -1
    
    private var oldItem: Item = Item()
    
    private var moveItemSection: String = ""
    
    weak var delegate: UpdateShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopListName = shoppingListToDisplay.getListName()
        setShopNames()
    }
    
    func setList(list: ShoppingList) {
        shoppingListToDisplay = list
    }
    
    func getList() -> ShoppingList {
        return shoppingListToDisplay
    }
    
    func setShoppingListNames(newList: [String]) {
        shoppingListNames = newList
    }
    
    func getShoppingListNames() -> [String] {
        return shoppingListNames
    }
    
    func setListName(name: String) {
        shopListName = name
    }
    
    func getListName() -> String {
        return shopListName
    }
    
    private func setShopNames() {
        let storesAndItems = shoppingListToDisplay.getStoresAndItems()
        
        for item in storesAndItems {
            if !shopNames.contains(item.key) {
                shopNames.append(item.key)
            }
        }
    }
    
    private func getNumberOfRowsInSection(index: Int) -> Int? {
        
        let key: String = shopNames[index]
        
        guard let count = shoppingListToDisplay.getNumberOfItems(with: key) else {
            return nil
        }
        
        return count
    }
    
    func setOldItem(item: Item) {
        oldItem = item
    }
    
    func getOldItem() -> Item {
        return oldItem
    }
    
    func getUpdateIndex() -> Int {
        return indexOfUpdatedItem
    }
    
    func setUpdateIndex(newIndex: Int) {
        indexOfUpdatedItem = newIndex
    }
    
    func getDeleteIndex() -> Int {
        return indexOfDeletedItem
    }
    
    func setDeleteIndex(newIndex: Int) {
        indexOfDeletedItem = newIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addItemToListVC = segue.destination as? AddItemToListViewController {
            
            addItemToListVC.delegate = self
            addItemToListVC.setShoppingList(newShoppingList: shoppingListToDisplay)
        }
        else if let updateItemInShoppingListVC = segue.destination as? UpdateItemInShoppingListViewController, segue.identifier == "updateItemInList" {
            print("Going to update Item")
            updateItemInShoppingListVC.delegate = self
            updateItemInShoppingListVC.setItemToChange(newItemToChange: sender as! Item)
        }
        else if let changeItemShoppingListVC = segue.destination as? ChangeItemShoppingListViewController, segue.identifier == "changeShoppingList" {
            print("Going to change item's shopping list")
            changeItemShoppingListVC.setListOfShoppingListNames(newList: shoppingListNames)
            changeItemShoppingListVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsInSection(index: section) ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return shoppingListToDisplay.getNumberOfKeys()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shopListDetailCell") as? ShoppingListDetailCell
            else { return UITableViewCell() }
        
        let sectionName: String = shopNames[indexPath.section]
        
        guard let displayItem = shoppingListToDisplay.getValue(key: sectionName, index: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.decorate(with: displayItem)
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return shopNames[section]
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let del = UITableViewRowAction(style: .destructive, title: "Delete Item") { action, index in
            print("Deleting item at index \(index.row) in shop \(self.shopNames[index.section]) in list \(self.shopListName)")
            let DELETE_KEY: String = self.shopNames[index.section]
            let DELETE_INDEX: Int = index.row
            self.delegate?.deleteItemFromList(key: DELETE_KEY, index: DELETE_INDEX)
            self.deleteEntry(key: DELETE_KEY, index: DELETE_INDEX)
            self.reloadTable()
        }
        let changeShoppingListOfItem = UITableViewRowAction(style: .normal, title: "Change List") { action, index in
            
            let CHANGE_KEY: String = self.shopNames[index.section]
            self.moveItemSection = CHANGE_KEY
            self.indexOfMovedItem = index.row
            
            print("Changing item at shop \(CHANGE_KEY) at index \(self.indexOfMovedItem)")
            
            self.performSegue(withIdentifier: "changeShoppingList", sender: index.row)
        }
        let updateShoppingListItem = UITableViewRowAction(style: .normal, title: "Update") { action, index in
            print("Updating item at index \(index.row)")
            let SECTION_NUMBER = index.section
            let SELECTED_INDEX = index.row
            
            guard let SELECTED_ITEM = self.getSelectedItem(section: SECTION_NUMBER, index: SELECTED_INDEX) else {
                return
            }
            
            self.setOldItem(item: SELECTED_ITEM)
            self.setUpdateIndex(newIndex: SELECTED_INDEX)
            self.performSegue(withIdentifier: "updateItemInList", sender: SELECTED_ITEM)
        }
        del.backgroundColor = UIColor.red
        changeShoppingListOfItem.backgroundColor = UIColor.green
        updateShoppingListItem.backgroundColor = UIColor.darkGray
        
        return [del, changeShoppingListOfItem, updateShoppingListItem]
    }
    
    // For editing an item in a shopping list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let SECTION_NUMBER = indexPath.section
        let SELECTED_ITEM_INDEX = indexPath.row
        
        let SELECTED_ITEM = getSelectedItem(section: SECTION_NUMBER, index: SELECTED_ITEM_INDEX)
        
        setOldItem(item: SELECTED_ITEM!)
        setUpdateIndex(newIndex: SELECTED_ITEM_INDEX)
        
        performSegue(withIdentifier: "updateItemInList", sender: SELECTED_ITEM!)
        */
        print("Selected item in \(indexPath.section) at \(indexPath.row)")
    }
    
    private func getSelectedItem(section: Int, index: Int) -> Item? {
        if !isSectionValid(sectionNumber: section) {
            return nil
        }
        
        if !isItemValid(sectionNumber: section, index: index) {
            return nil
        }
        let SECTION_NAME: String = shopNames.at(index: section)!
        return shoppingListToDisplay.getValue(key: SECTION_NAME, index: index)
    }
    
    private func isSectionValid(sectionNumber: Int) -> Bool {
        return shopNames.at(index: sectionNumber) != nil
    }
    
    private func isItemValid(sectionNumber: Int, index:Int) -> Bool {
        guard let SECTION_NAME = shopNames.at(index: sectionNumber) else {
            return false
        }
        
        guard shoppingListToDisplay.getValue(key: SECTION_NAME, index: index) != nil else {
            return false
        }
        
        return true
    }
    private func deleteItem(key: String, index: Int) {
        shoppingListToDisplay.deleteEntry(key: key, index: index)
    }
    
    private func deleteEntry(key: String, index: Int) {
        deleteItem(key: key, index: index)
        deleteKey(key: key)
    }
    
    private func deleteKey(key: String) {
        if shoppingListToDisplay.getNumberOfItems(with: key) == 0 {
            shoppingListToDisplay.deleteKey(key: key)
            deleteTableSection(shopName: key)
        }
    }
    
    private func deleteTableSection(shopName: String) {
        if let deleteIndex = shopNames.firstIndex(of: shopName) {
            shopNames.remove(at: deleteIndex)
        }
    }
    
    func add(item: Item) {
        print("Item to add is \(item)")
        
        if shoppingListToDisplay.doesKeyExist(key: item.shopName) {
            shoppingListToDisplay.addItemToKey(item: item)
        }
        else {
            shoppingListToDisplay.createKey(keyName: item.shopName)
            shoppingListToDisplay.addItemToKey(item: item)
            shopNames.append(item.shopName)
        }
        delegate?.addItemToShoppingList(item: item)
        reloadTable()
    }
    
    func updateItem(updatedItem: Item, update: UpdateShoppingListCase) {
        delegate?.updateItemFromList(key: getOldItem().shopName, index: indexOfUpdatedItem, newItem: updatedItem)
        addItemToShoppingList(oldItem: getOldItem(), updatedItem: updatedItem)
        reloadTable()
    }
    
    func addItemToShoppingList(oldItem: Item, updatedItem: Item) {
        let KEY: String = getOldItem().shopName
        let UPDATE_INDEX: Int = getUpdateIndex()
        
        if (!doStoresMatch(oldStore: oldItem.shopName, newStore: updatedItem.shopName)) {
            deleteEntry(key: KEY, index: UPDATE_INDEX)
            add(item: updatedItem)
        }
        else {
            shoppingListToDisplay.updateEntry(item: updatedItem, indexOfUpdate: UPDATE_INDEX)
        }
    }
    
    func move(list: String) {
        print("Moving item to \(list)")
        guard let OLD_ITEM: Item = shoppingListToDisplay.getValue(key: moveItemSection, index: indexOfMovedItem) else {
            return
        }
        let NEW_ITEM: Item = shoppingListToDisplay.changeShoppingList(oldItem: OLD_ITEM, newListName: list)
        
        delegate?.move(item: NEW_ITEM, to: list, oldItem: OLD_ITEM, indexOfMovedItem: indexOfMovedItem)
        shoppingListToDisplay.deleteItemFromList(key: moveItemSection, index: indexOfMovedItem)
        reloadTable()
    }
    
    func doStoresMatch(oldStore: String, newStore: String) -> Bool {
        return oldStore == newStore
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
}
