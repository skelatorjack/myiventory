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
    func updateItem(item: Item, at index: Int)
}

class UpdateItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var updateNameField: UITextField!
    @IBOutlet weak var updateQuantityField: UITextField!
    @IBOutlet weak var updateOwnerField: UITextField!
    
    @IBOutlet weak var updateItemButton: UIButton!
    
    weak var delegate: UpdateItemDelegate?
    
    private var nameValue: String = ""
    private var quantityValue: String = ""
    private var ownerValue: String = ""
    private var shopListValue: String = ""
    
    private var item: Item = Item()
    
    private var updateItemIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNameField.text = nameValue
        updateQuantityField.text = quantityValue
        updateOwnerField.text = ownerValue
        
        updateNameField.delegate = self
        updateOwnerField.delegate = self
        updateQuantityField.delegate = self
        
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
    
    func enableUpdateItem() {
        let name: String = updateNameField.text!
        let quantity: String = updateQuantityField.text!
        let owner: String = updateOwnerField.text!
        
        item.clear()
        item.parseData(name: name, quantity: quantity, owner: owner)
        
        if item.isItemValid(itemType:ItemType.InventoryItem) {
            updateItemButton.isEnabled = true
        }
        else {
            updateItemButton.isEnabled = false
        }
    }
    
    func setValues(name: String, quantity: String, owner: String, index: Int, list: String) {
        nameValue = name
        quantityValue = quantity
        ownerValue = owner
        updateItemIndex = index
        shopListValue = list
    }
    
    @IBAction func updateItemPressed(_ sender: UIButton) {
        print("Update Item pressed")
        
        delegate?.updateItem(item: item, at: updateItemIndex)
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
