//
//  AddItemToListViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/25/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemToList: class {
    func add(item: Item)
}

class AddItemToListViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, AddImageDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    @IBOutlet weak var storeField: UITextField!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItemToList: UIButton!
    
    weak var delegate: AddItemToList?
    
    private var shoppingListToChange: ShoppingList = ShoppingList()
    private var image: UIImage? = nil
    
    private let itemCategoryList: Array<ItemCategory> = [ItemCategory.Food, ItemCategory.Cleaning, ItemCategory.Clothes, ItemCategory.Fashion, ItemCategory.Tech, ItemCategory.Tools, ItemCategory.Yard, ItemCategory.Other]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        quantityField.delegate = self
        ownerField.delegate = self
        storeField.delegate = self
        
        addItemToList.isEnabled = false
        
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addImageVC = segue.destination as? AddImageViewController, segue.identifier == Segues.AddImageFromShoppingList.rawValue {
            addImageVC.delegate = self
        }
    }
    @IBAction func onAddImagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.AddImageFromShoppingList.rawValue
            , sender: nil)
    }
    @IBAction func addItemToListPressed(_ sender: UIButton) {
        guard let nameText = nameField.text,
            let quantityText = Int(quantityField.text!),
            let ownerText = ownerField.text,
            let storeText = storeField.text  else { return }
        
        var hasItem: Bool = false
        if image != nil {
            hasItem = true
        }
        
        let item = Item(newName: nameText, newOwner: ownerText, newQuantity: quantityText, newShoppingList: shoppingListToChange.getListName(), shopName: storeText, newCategory: getItemCategory(), newShoppingListID: shoppingListToChange.getShoppingListId(), hasImage: hasItem, isInventoryItem: false, newItemImage: image)
        
        delegate?.add(item: item)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func setShoppingList(newShoppingList: ShoppingList) {
        shoppingListToChange = newShoppingList
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
        enableAddItemToList()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableAddItemToList()
        return true
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
    
    private func enableAddItemToList() {
        let nameText     = nameField.text
        let quantityText = quantityField.text
        let ownerText    = ownerField.text
        let storeText    = storeField.text
        
        if isTextFieldNotEmpty(text: nameText),
            isTextFieldNotEmpty(text: quantityText),
            isTextFieldNotEmpty(text: ownerText),
            isTextFieldNotEmpty(text: storeText) {
            
            addItemToList.isEnabled = true
        }
        else {
            addItemToList.isEnabled = false
        }
    }
    
    private func isTextFieldNotEmpty(text: String?) -> Bool {
        return text != "" && text != nil
    }
    
    private func getItemCategory() -> ItemCategory {
        print("Selected \(itemTypePicker.selectedRow(inComponent: 0))")
        return itemCategoryList[itemTypePicker.selectedRow(inComponent: 0)]
    }
    
    func add(image: UIImage?) {
        self.image = image
    }
}
