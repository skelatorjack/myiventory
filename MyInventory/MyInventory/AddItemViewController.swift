//
//  AddItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    
    @IBOutlet weak var addItem: UIButton!
    
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func addItemPressed(_ sender: UIButton) {
        print("Add Item pressed.")
    }
}
