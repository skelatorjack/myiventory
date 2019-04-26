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


class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AddImageDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var addItem: UIButton!
    
    weak var delegate: AddItemDelegate?
    var itemImage: UIImage? = nil
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addImageVC = segue.destination as? AddImageViewController, segue.identifier == Segues.AddImage.rawValue {
            print("Segueing to AddImageViewController.")
            addImageVC.delegate = self
        }
    }
    func enableAddItemPressed() {
        let name: String = nameField.text!
        guard let quantityString = quantityField.text, let quantity = Int(quantityString) else {
            return
        }
        let owner: String = ownerField.text!
        
        
        if Item.isInventoryItemValid(name: name, itemOwner: owner, itemQuantity: quantity) {
            addItem.isEnabled = true
        }
        else {
            addItem.isEnabled = false
        }
    }

    func add(image: UIImage?) {
        print("Adding image to item.")
        itemImage = image
    }
 
    @IBAction func addItemPressed(_ sender: UIButton) {
        print("Add Item pressed.")
        
        guard let newItem = setUpNewItem() else {
            return
        }
        print("Adding new item as \(newItem)")
        delegate?.addItem(item: newItem)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddImagePressed(_ sender: Any) {
        print("Add Image Pressed")
        performSegue(withIdentifier: Segues.AddImage.rawValue, sender: nil)
    }
    private func getItemCategory() -> ItemCategory {
        print("Selected \(itemTypePicker.selectedRow(inComponent: 0))")
        return itemCategoryList[itemTypePicker.selectedRow(inComponent: 0)]
    }
    
    private func setUpNewItem() -> Item? {
        var isImageSelected = false
        guard let name = nameField.text, let owner = ownerField.text, let quantity = convertQuantityToInt(quantity: quantityField.text) else {
            return nil
        }
        if itemImage != nil {
            isImageSelected = true
        }
        return Item(newName: name, newOwner: owner, newQuantity: quantity, newCategory: getItemCategory(), hasImage: isImageSelected, isInventoryItem: true)
    }
    
    private func convertQuantityToInt(quantity: String?) -> Int? {
        guard let quantityString = quantity, let quantityInt = Int(quantityString) else {
            return nil
        }
        return quantityInt
    }
}
