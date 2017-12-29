//
//  UpdateItemInShoppingListViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 12/28/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateItemInShoppingListDelegate: class {
    func updateItem(itemToUpdate: Item, update: UpdateShoppingListCase)
}
class UpdateItemInShoppingListViewController: UIViewController, UITextFieldDelegate {
    
    private var itemToChange: Item = Item()
    weak var delegate: UpdateItemInShoppingListDelegate?
    
    // IBOutlets and actions
    @IBOutlet weak var updateNameField: UITextField!
    @IBOutlet weak var updateQuantityField: UITextField!
    @IBOutlet weak var updateOwnerField: UITextField!
    @IBOutlet weak var updateStoreField: UITextField!
    
    @IBOutlet weak var updateItemButton: UIButton!
    
    @IBAction func updateItemPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        updateNameField.text = itemToChange.itemName
        updateOwnerField.text = itemToChange.itemOwner
        updateQuantityField.text = "\(itemToChange.itemQuantity)"
        updateStoreField.text = itemToChange.shopName
        updateItemButton.isEnabled = false
    }
    
    func setItemToChange(newItemToChange: Item) {
        itemToChange = newItemToChange
    }
    
    func getItemToChange() -> Item {
        return itemToChange
    }
    
    
}
