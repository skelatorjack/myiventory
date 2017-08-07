//
//  AddItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 7/23/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    
    @IBOutlet weak var addItem: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addItemPressed(_ sender: UIButton) {
        
    }
}
