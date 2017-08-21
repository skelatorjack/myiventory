//
//  ShoppingListTableCell.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListTableCell: UITableViewCell {
    
    @IBOutlet weak var shoppingListNameLabel: UILabel!
    @IBOutlet weak var shoppingListCountLabel: UILabel!
    
    func decorate(with shoppingList: ShoppingList) {
        shoppingListNameLabel.text = shoppingList.getListName()
        shoppingListCountLabel.text = "\(shoppingList.getTotalNumberOfItems())"
    }
}
