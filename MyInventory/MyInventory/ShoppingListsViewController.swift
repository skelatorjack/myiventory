//
//  ShoppingListsViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListsViewController: UITableViewController, AddShoppingList {
    
    private var shoppingLists: [ShoppingList] = []
    
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
            
            shopListDetail.setList(list: shoppingLists[indexOfList])
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
        reloadTable()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}
