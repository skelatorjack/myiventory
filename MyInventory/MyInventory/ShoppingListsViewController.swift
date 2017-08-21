//
//  ShoppingListsViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListsViewController: UITableViewController {
    
    var shoppingLists: [ShoppingList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
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
}
