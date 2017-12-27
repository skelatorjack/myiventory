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
}

enum UpdateShoppingListCase {
    case AddShopList
    case AddItemToShopList
    case DeleteItemFromShopList
    case UpdateItemFromShopList
    case DeleteShopList
}

class ShoppingListsViewController: UITableViewController, AddShoppingList, UpdateShoppingList, AddItemToList {
    
    private var shoppingLists: [ShoppingList] = []
    private var indexOfShoppingList: Int = -1
    
    weak var delegate: UpdateUserWithShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setShoppingLists(userShoppingLists: [ShoppingList]) {
        shoppingLists = userShoppingLists
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
            
            shopListDetail.delegate = self
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
    
    func add(shoppingListName: String) {
        
        let newShoppingList: ShoppingList = ShoppingList(listName: shoppingListName)
        
        shoppingLists.append(newShoppingList)
        update(shoppingList: newShoppingList, update: UpdateShoppingListCase.AddShopList)
    }
    
    func add(item: Item) {
        let shoppingListToChange: ShoppingList? = shoppingLists.at(index: indexOfShoppingList)
        
        if shoppingListToChange != nil {
            shoppingListToChange?.addItemToKey(item: item)
            
            update(shoppingList: shoppingListToChange!, update: UpdateShoppingListCase.AddItemToShopList)
        }
    }
    
    func update(shoppingList: ShoppingList, update: UpdateShoppingListCase) {
        switch update {
        case .AddItemToShopList:
            delegate?.updateUser(with: shoppingList, at: indexOfShoppingList, update: "addItem")
            
        case .AddShopList:
            delegate?.updateUser(with: shoppingList, at: indexOfShoppingList, update: "addShopList")
            
        default: break
        }
        
        reloadTable()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}
