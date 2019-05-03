//
//  UpdateItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/8/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateItemDelegate: class {
    func updateItem(at index: Int, with item: UpdatedItem)
}

class UpdateItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var updateNameField: UITextField!
    @IBOutlet weak var updateQuantityField: UITextField!
    @IBOutlet weak var updateOwnerField: UITextField!
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var updateItemButton: UIButton!
    
    weak var delegate: UpdateItemDelegate?
    
    var itemToUpdate: UpdatedItem = UpdatedItem()
    
    var updateItemIndex: Int = -1
    var itemImage: UIImage? = nil
    
    private let itemCategoryList: Array<ItemCategory> = [ItemCategory.Food, ItemCategory.Cleaning, ItemCategory.Clothes, ItemCategory.Fashion, ItemCategory.Tech, ItemCategory.Tools, ItemCategory.Yard, ItemCategory.Other]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNameField.text = itemToUpdate.itemName
        updateQuantityField.text = "\(itemToUpdate.itemQuantity)"
        updateOwnerField.text = itemToUpdate.itemOwner
        
        updateNameField.delegate = self
        updateOwnerField.delegate = self
        updateQuantityField.delegate = self
        
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        // Setup tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
        enableUpdateItem()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableUpdateItem()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addImageVC = segue.destination as? AddImageViewController, segue.identifier == Segues.AddImageFromUpdate.rawValue {
            print("Segueing to AddImageViewController from UpdateItem.")
        }
    }
    func enableUpdateItem() {
        let name: String = updateNameField.text!
        let quantity: String = updateQuantityField.text!
        let owner: String = updateOwnerField.text!
       
        itemToUpdate.itemName = name
        itemToUpdate.itemOwner = owner
        
        guard let quantityAsInt = Int(quantity) else {
            return
        }
        itemToUpdate.itemQuantity = quantityAsInt
        
        if itemToUpdate.isItemValid(itemType: .InventoryItem) {
            updateItemButton.isEnabled = true
        }
        else {
            updateItemButton.isEnabled = false
        }
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
    
    @IBAction func updateItemPressed(_ sender: UIButton) {
        print("Update Item pressed")
        itemToUpdate.itemCategory = getItemCategory()
        
        delegate?.updateItem(at: updateItemIndex, with: itemToUpdate)
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func onAddImagePressed(_ sender: Any) {
        performSegue(withIdentifier: Segues.AddImageFromUpdate.rawValue, sender: nil)
    }
    private func getItemCategory() -> ItemCategory {
        print("Selected \(itemTypePicker.selectedRow(inComponent: 0))")
        return itemCategoryList[itemTypePicker.selectedRow(inComponent: 0)]
    }
}
