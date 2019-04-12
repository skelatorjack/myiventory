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

class AddItemToListViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    @IBOutlet weak var storeField: UITextField!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItemToList: UIButton!
    
    weak var delegate: AddItemToList?
    
    private var shopListName: String = ""
    
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
    
    @IBAction func addItemToListPressed(_ sender: UIButton) {
        guard let nameText = nameField.text,
            let quantityText = Int(quantityField.text!),
            let ownerText = ownerField.text,
            let storeText = storeField.text  else { return }
        
        let item = Item(newName: nameText, newOwner: ownerText, newQuantity: quantityText, newShoppingList: shopListName, shopName: storeText, newCategory: getItemCategory())
        
        delegate?.add(item: item)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func setShopList(name: String) {
        shopListName = name
    }
    
    func getShopListName() -> String {
        return shopListName
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
}
