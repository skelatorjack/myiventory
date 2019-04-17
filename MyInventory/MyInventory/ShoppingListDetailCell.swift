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
    @IBOutlet weak var cellIcon: UIImageView!
    
    
    func decorate(with item: Item) {
        nameLabel.text = item.itemName
        quantityLabel.text = "\(item.itemQuantity)"
        ownerLabel.text = item.itemOwner
        setIcon(with: item)
    }
    
    private func setIcon(with item: Item) {
        switch item.itemCategory {
        case .Cleaning: setImage(using: "Cleaning")
        case .Clothes: setImage(using: "Clothing")
        case .Food: setImage(using: "Food")
        case .Fashion: setImage(using: "Fashion")
        case .Tech: setImage(using: "Tech")
        case .Tools: setImage(using: "Tools")
        case .Yard: setImage(using: "Yard")
        default: return
        }
    }
    
    private func setImage(using fileName: String) {
        cellIcon.image = UIImage(named: fileName)
    }
}
