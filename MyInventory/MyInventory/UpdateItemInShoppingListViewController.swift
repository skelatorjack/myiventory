
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

class UpdateItemInShoppingListViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, AddImageDelegate {
    
    private var image: UIImage? = nil
    private var itemToChange: Item = Item()
    weak var delegate: UpdateItemInShoppingListDelegate?
    private let itemCategoryList: Array<ItemCategory> = [ItemCategory.Food, ItemCategory.Cleaning, ItemCategory.Clothes, ItemCategory.Fashion, ItemCategory.Tech, ItemCategory.Tools, ItemCategory.Yard, ItemCategory.Other]
    // IBOutlets and actions
    @IBOutlet weak var updateNameField: UITextField!
    @IBOutlet weak var updateQuantityField: UITextField!
    @IBOutlet weak var updateOwnerField: UITextField!
    @IBOutlet weak var updateStoreField: UITextField!
     @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var updateItemButton: UIButton!
    
    @IBAction func updateItemPressed(_ sender: UIButton) {
        let updatedItem: Item = createItem()
        
        delegate?.updateItem(updatedItem: updatedItem, update: UpdateShoppingListCase.UpdateItemFromShopList)
        
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func onAddImagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.AddImageFromUpdateShoppingListItem.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addImageVC = segue.destination as? AddImageViewController, segue.identifier == Segues.AddImageFromUpdateShoppingListItem.rawValue {
            addImageVC.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNameField.text = itemToChange.itemName
        updateOwnerField.text = itemToChange.itemOwner
        updateQuantityField.text = "\(itemToChange.itemQuantity)"
        updateStoreField.text = itemToChange.shopName
        updateItemButton.isEnabled = false
        
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemCategoryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemCategoryList[row].rawValue
    }
    
    private func validateInput() {
        let updatedItem = createItem()
        
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
        var hasImage: Bool = false
        
        if image != nil {
            hasImage = true
        }
        
        let updatedItem: Item = Item(newName: updatedName, newOwner: updatedOwner, newQuantity: Int(updatedQuantity)!, newShoppingList: updatedShopList, shopName: updatedStore, newCategory: getItemCategory(), newShoppingListID: itemToChange.itemId, newItemId: itemToChange.itemId, hasImage: hasImage, isInventoryItem: false, newItemImage: image)
        
        return updatedItem
    }
    private func getItemCategory() -> ItemCategory {
        print("Selected \(itemTypePicker.selectedRow(inComponent: 0))")
        return itemCategoryList[itemTypePicker.selectedRow(inComponent: 0)]
    }
    
    func add(image: UIImage?) {
        self.image = image
    }
}
