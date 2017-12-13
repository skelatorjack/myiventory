//
//  ShoppingListDetailCell.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/22/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListDetailCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    
    func decorate(with item: Item) {
        nameLabel.text = item.itemName
        quantityLabel.text = "\(item.itemQuantity)"
        ownerLabel.text = item.itemOwner
    }
}
