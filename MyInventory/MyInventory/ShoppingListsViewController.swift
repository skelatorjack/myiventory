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

class ShoppingListsViewController: UITableViewController, AddShoppingList, UpdateShoppingList {
    
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
        delegate?.add(shoppingList: newShoppingList)
        reloadTable()
    }
    
    func update(shoppingList: ShoppingList, update: String) {
        
        switch update {
        case "add": shoppingLists.append(shoppingList)
        default: break
        }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}
