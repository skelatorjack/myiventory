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

class ShoppingListsViewController: UITableViewController, AddShoppingList, UpdateShoppingList, AddItemToList, UpdateShoppingListName {
    
    private var shoppingLists: [ShoppingList] = []
    private var shoppingListNames: [String] = []
    
    private var indexOfShoppingList: Int = -1
    
    weak var delegate: UpdateUserWithShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let shoppingList:ShoppingList = self.shoppingLists[index.row]
            self.shoppingLists.remove(at: index.row)
            self.removeShoppingListName(at: index.row)
            self.update(shoppingList: shoppingList, update: UpdateShoppingListCase.DeleteShopList)
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
        
        case .DeleteItemFromShopList:
            break
            
        case .AddShopList:
           addShoppingListName(newName: shoppingList.getListName())
           delegate?.add(shoppingList: shoppingList)
            
        case .DeleteShopList:
            break
            
        default: break
        }
        
        reloadTable()
    }
    
    func update(shoppingListName: String) {
        shoppingLists[indexOfShoppingList].setListName(name: shoppingListName)
        shoppingListNames[indexOfShoppingList] = shoppingLists[indexOfShoppingList].getListName()
        shoppingLists[indexOfShoppingList].updateItemsInShoppingList()
        reloadTable()
    }
    
    func move(item: Item) {
        let INDEX_OF_ITEM: Int = shoppingLists.index(where: { $0.getListName().hasPrefix(item.shoppingList) })!
        
        shoppingLists[INDEX_OF_ITEM].addItemToKey(item: item)
        reloadTable()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}
