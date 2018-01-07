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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateListNamePressed(_ sender: UIButton) {
    }
    
    func setNewListName(newName: String) {
        newListName = newName
    }
    
    func getNewListName() -> String {
        return newListName
    }
    
    func isNameValid(listName: String) -> Bool {
        return true
    }
    
}
