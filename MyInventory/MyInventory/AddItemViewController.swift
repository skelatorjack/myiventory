//
//  AddItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemDelegate: class {
    func addItem(item: Item)
}


class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItem: UIButton!
    
    weak var delegate: AddItemDelegate?

    private var newItem: Item = Item()
    private let itemCategoryList: Array<ItemCategory> = [ItemCategory.Food, ItemCategory.Cleaning, ItemCategory.Clothes, ItemCategory.Fashion, ItemCategory.Tech, ItemCategory.Tools, ItemCategory.Yard, ItemCategory.Other]

    override func viewDidLoad() {
        super.viewDidLoad()
        addItem.isEnabled = false
        
        // set textfield delegates
        nameField.delegate = self
        quantityField.delegate = self
        ownerField.delegate = self
        
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        
        // set tap gesture recognize
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
        enableAddItemPressed()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableAddItemPressed()
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
    
    func enableAddItemPressed() {
        let name: String = nameField.text!
        let quantity: String = quantityField.text!
        let owner: String = ownerField.text!
        
        newItem.clear()
        newItem.parseData(name: name, quantity: quantity, owner: owner)
        
        if newItem.isItemValid(itemType:ItemType.InventoryItem) {
            addItem.isEnabled = true
        }
        else {
            addItem.isEnabled = false
        }
    }
    @IBAction func addItemPressed(_ sender: UIButton) {
        print("Add Item pressed.")
        newItem.itemCategory = getItemCategory()
        delegate?.addItem(item: newItem)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    private func getItemCategory() -> ItemCategory {
        print("Selected \(itemTypePicker.selectedRow(inComponent: 0))")
        return itemCategoryList[itemTypePicker.selectedRow(inComponent: 0)]
    }
}
