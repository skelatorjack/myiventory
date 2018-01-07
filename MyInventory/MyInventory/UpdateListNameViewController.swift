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
    
    weak var delegate: UpdateShoppingListName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    @IBAction func updateListNamePressed(_ sender: UIButton) {
    }
    
    func setNewListName(newName: String) {
        newListName = newName
    }
    
    func getNewListName() -> String {
        return newListName
    }
    
    private func isNameValid(listName: String) -> Bool {
        return true
    }
    
    @objc private func backgroundTapped() {
        
    }
    
}
