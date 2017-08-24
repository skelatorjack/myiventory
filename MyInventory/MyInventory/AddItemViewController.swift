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


class AddItemViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    
    @IBOutlet weak var addItem: UIButton!
    
    weak var delegate: AddItemDelegate?
    
    private var newItem: Item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItem.isEnabled = false
        
        // set textfield delegates
        nameField.delegate = self
        quantityField.delegate = self
        ownerField.delegate = self
        
        // set tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    func backgroundTapped() {
        view.endEditing(true)
        enableAddItemPressed()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableAddItemPressed()
        return true
    }
    
    func enableAddItemPressed() {
        let name: String = nameField.text!
        let quantity: String = quantityField.text!
        let owner: String = ownerField.text!
        
        newItem.clear()
        newItem.parseData(name: name, quantity: quantity, owner: owner)
        
        if newItem.isItemValid() {
            addItem.isEnabled = true
        }
        else {
            addItem.isEnabled = false
        }
    }
    @IBAction func addItemPressed(_ sender: UIButton) {
        print("Add Item pressed.")
        
        delegate?.addItem(item: newItem)
        let _ = navigationController?.popViewController(animated: true)
    }
}
