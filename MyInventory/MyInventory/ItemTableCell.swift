//
//  ItemTableCell.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class ItemTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    func decorate(with item: Item?) {
        nameLabel.text = item?.itemName
        ownerLabel.text = item?.itemOwner
        quantityLabel.text = item?.quantityToString()
    }
}
