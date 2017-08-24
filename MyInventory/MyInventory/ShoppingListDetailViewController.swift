//
//  ShoppingListDetailViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListDetailViewController: UITableViewController {
    
    private var shoppingListToDisplay: ShoppingList = ShoppingList()
    private var shopNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListToDisplay.createKey(keyName: "Store")
        let item = Item(newName: "Toothpaste", newOwner: "Jack", newQuantity: 1, newShoppingList: "Store")
        
        let item2 = Item(newName: "Mouthwash", newOwner: "Jack", newQuantity: 1, newShoppingList: "Store")
        
        shoppingListToDisplay.addItemToKey(item: item)
        shoppingListToDisplay.addItemToKey(item: item2)
        
        setShopNames()
    }
    
    func setList(list: ShoppingList) {
        shoppingListToDisplay = list
    }
    
    func getList() -> ShoppingList {
        return shoppingListToDisplay
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
        
        cell.decorate()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return shopNames[section]
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
