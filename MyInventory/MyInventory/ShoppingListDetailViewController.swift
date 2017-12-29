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
    func update(shoppingList: ShoppingList, update: UpdateShoppingListCase)
}

class ShoppingListDetailViewController: UITableViewController, AddItemToList, UpdateItemInShoppingListDelegate {
    
    private var shoppingListToDisplay: ShoppingList = ShoppingList()
    private var shopNames: [String] = []
    private var shopListName: String = ""
    
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
    
    func setListName(name: String) {
        shopListName = name
    }
    
    func getListName() -> String {
        return shopListName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addItemToListVC = segue.destination as? AddItemToListViewController {
            
            addItemToListVC.delegate = self
            addItemToListVC.setShopList(name: shopListName)
        }
        else if let updateItemInShoppingListVC = segue.destination as? UpdateItemInShoppingListViewController, segue.identifier == "updateItemInList" {
            print("Going to update Item")
            updateItemInShoppingListVC.delegate = self
            updateItemInShoppingListVC.setItemToChange(newItemToChange: sender as! Item)
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
            
            self.deleteEntry(key: DELETE_KEY, index: DELETE_INDEX)
            self.delegate?.update(shoppingList: self.shoppingListToDisplay, update: UpdateShoppingListCase.DeleteItemFromShopList)
            self.reloadTable()
        }
        del.backgroundColor = UIColor.red
        
        return [del]
    }
    
    // For editing an item in a shopping list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SECTION_NUMBER = indexPath.section
        let SELECTED_ITEM_INDEX = indexPath.row
        
        let SELECTED_ITEM = getSelectedItem(section: SECTION_NUMBER, index: SELECTED_ITEM_INDEX)
        
        performSegue(withIdentifier: "updateItemInList", sender: SELECTED_ITEM!)
        
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
        if let deleteIndex = shopNames.index(of: shopName) {
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
        delegate?.update(shoppingList: shoppingListToDisplay, update: UpdateShoppingListCase.AddItemToShopList)
        reloadTable()
    }
    
    func updateItem(itemToUpdate: Item, update: UpdateShoppingListCase) {
    
    }
    private func reloadTable() {
        tableView.reloadData()
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
}
