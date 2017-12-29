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

class ShoppingListDetailViewController: UITableViewController, AddItemToList {
    
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
        else if let updateItemInShoppingListVC = segue.destination as? UpdateItemInShoppingListViewController {
            print("Going to update Item")
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
        
    }
    
    func deleteItem(key: String, index: Int) {
        shoppingListToDisplay.deleteEntry(key: key, index: index)
    }
    
    func deleteEntry(key: String, index: Int) {
        deleteItem(key: key, index: index)
        deleteKey(key: key)
    }
    
    func deleteKey(key: String) {
        if shoppingListToDisplay.getNumberOfItems(with: key) == 0 {
            shoppingListToDisplay.deleteKey(key: key)
            deleteTableSection(shopName: key)
        }
    }
    
    func deleteTableSection(shopName: String) {
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
