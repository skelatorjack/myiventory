//
//  ChangeItemShoppingListViewController.swift
//  MyInventory
//
//  Allows the user to move a shopping list item to a new list that
//  already exists.
//  Created by Jack Pettit on 1/7/18.
//  Copyright © 2018 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeItemShoppingListDelegate: class {
    func move(list: String)
}

class ChangeItemShoppingListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var changeShoppingListButton: UIButton!
    @IBOutlet weak var shoppingListPicker: UIPickerView!
    
    private var listOfShoppingListNames: [String] = []
    
    weak var delegate: ChangeItemShoppingListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListPicker.delegate = self
        shoppingListPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfShoppingListNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfShoppingListNames[row]
    }
    
    func setListOfShoppingListNames(newList: [String] = []) {
        listOfShoppingListNames = newList
    }
    
    func getListOfShoppingListNames() -> [String] {
        return listOfShoppingListNames
    }
    
    @IBAction func changeShoppingListPressed(_ sender: UIButton) {
        var newListName: String = ""
        
        newListName = listOfShoppingListNames[shoppingListPicker.selectedRow(inComponent: 0)]
        
        delegate?.move(list: newListName)
        popViewController()
    }
    
    private func popViewController() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
