//
//  UpdateItemInShoppingListViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 12/28/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

enum ButtonStatus {
    case on
    case off
}

protocol UpdateItemInShoppingListDelegate: class {
    func updateItem(updatedItem: Item, update: UpdateShoppingListCase)
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
        let updatedItem: Item = createItem()
        
        delegate?.updateItem(updatedItem: updatedItem, update: UpdateShoppingListCase.UpdateItemFromShopList)
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNameField.text = itemToChange.itemName
        updateOwnerField.text = itemToChange.itemOwner
        updateQuantityField.text = "\(itemToChange.itemQuantity)"
        updateStoreField.text = itemToChange.shopName
        updateItemButton.isEnabled = false
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
        validateInput()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        validateInput()
        
        return true
    }
    
    func setItemToChange(newItemToChange: Item) {
        itemToChange = newItemToChange
    }
    
    func getItemToChange() -> Item {
        return itemToChange
    }
    
    private func validateInput() {
        let updatedItem: Item = createItem()
        
        if updatedItem.isItemValid(itemType:ItemType.ShoppingListItem) {
            updateItemButton.isEnabled = true
        }
        else {
            updateItemButton.isEnabled = false
        }
    }
    
    private func createItem() -> Item {
        let updatedName: String = updateNameField.text!
        let updatedQuantity: String = updateQuantityField.text!
        let updatedOwner: String = updateOwnerField.text!
        let updatedStore: String = updateStoreField.text!
        let updatedShopList: String = itemToChange.shoppingList
        
        let updatedItem: Item = Item(newName: updatedName, newOwner: updatedOwner, newQuantity: Int(updatedQuantity)!, newShoppingList: updatedShopList, shopName: updatedStore)
        
        return updatedItem
    }
}
