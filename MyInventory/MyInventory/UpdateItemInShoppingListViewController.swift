//
//  UpdateItemInShoppingListViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 12/28/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateItemInShoppingListDelegate: class {
    func updateItem(itemToUpdate: Item, update: UpdateShoppingListCase)
}
class UpdateItemInShoppingListViewController: UIViewController, UITextFieldDelegate {
    
    private var itemListToChange: Item = Item()
    weak var delegate: UpdateItemInShoppingListDelegate?
    
    // IBOutlets and actions
}
