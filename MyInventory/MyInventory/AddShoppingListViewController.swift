//
//  AddShoppingListViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/21/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol AddShoppingList: class {
    func add(shoppingListName: String)
}

class AddShoppingListViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var listNameTextField: UITextField!
    @IBOutlet weak var addShoppingListButton: UIButton!
    
    weak var delegate: AddShoppingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        addShoppingListButton.isEnabled = false
    }
    
    @IBAction func addShoppingListPressed(_ sender: UIButton) {
        guard let shoppingListName = listNameTextField.text else {
            return
        }
        
        delegate?.add(shoppingListName: shoppingListName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func backgroundTapped() {
        view.endEditing(true)
        enableAddShoppingList()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableAddShoppingList()
        return true
    }
    
    private func isListNameValid() -> Bool {
        
        if listNameTextField.text != "", listNameTextField.text != nil {
            return true
        }
        return false
    }
    
    private func enableAddShoppingList() {
        
        if isListNameValid() {
            addShoppingListButton.isEnabled = true
        }
    }
    
}
