//
//  DisplayItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/23/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import UIKit

class DisplayItemViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var viewImageButton: UIButton!
    
    var displayItem: Item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if displayItem.hasImage {
            viewImageButton.isEnabled = true
        } else {
            viewImageButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
        setItemNameLabel(with: displayItem.itemName)
        setItemTypeLabel(with: displayItem.itemCategory)
        setItemQuantityLabel(with: displayItem.itemQuantity)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setItemNameLabel(with name: String) {
        itemNameLabel.text = "Item Name: \(name)"
    }
    
    func setItemQuantityLabel(with quantity: Int) {
        itemQuantityLabel.text = "Item Quantity: \(quantity)"
    }
    
    func setItemTypeLabel(with type: ItemCategory) {
        itemTypeLabel.text = "Item Type: \(type.rawValue)"
    }
}
