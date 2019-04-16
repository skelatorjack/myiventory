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
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    func decorate(with item: Item?) {
        nameLabel.text = item?.itemName
        ownerLabel.text = item?.itemOwner
        quantityLabel.text = item?.quantityToString()
        setIcon(using: item)
    }
    
    private func setIcon(using item: Item?) {
        guard let itemCategory = item?.itemCategory else {
            return
        }
        switch itemCategory {
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
        iconImageView.image = UIImage(named: fileName)
    }
}
