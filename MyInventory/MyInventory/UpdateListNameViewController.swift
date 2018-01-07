//
//  UpdateListNameViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 1/4/18.
//  Copyright © 2018 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateShoppingListName: class {
    func update(shoppingListName: String)
}

class UpdateListNameViewController: UIViewController, UITextFieldDelegate {
    
    private var newListName: String = ""
    
    @IBOutlet weak var listNameField: UITextField!
    @IBOutlet weak var updateListNameButton: UIButton!
    
    weak var delegate: UpdateShoppingListName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        updateListNameButton.isEnabled = false
    }
    
    @IBAction func updateListNamePressed(_ sender: UIButton) {
        print("Button pressed. The shop list name is \(listNameField.text!)")
        setNewListName(newName: listNameField.text!)
        delegate?.update(shoppingListName: getNewListName())
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        enableButton()
        return true
    }
    func setNewListName(newName: String) {
        newListName = newName
    }
    
    func getNewListName() -> String {
        return newListName
    }
    
    private func isNameValid(listName: String) -> Bool {
        return !listName.isEmpty && listNameField.text != nil
    }
    
    private func enableButton() {
        if isNameValid(listName: listNameField.text!) {
            updateListNameButton.isEnabled = true
        }
        else {
            updateListNameButton.isEnabled = false
        }
    }
    
    @objc private func backgroundTapped() {
        view.endEditing(true)
        enableButton()
    }
    
}
