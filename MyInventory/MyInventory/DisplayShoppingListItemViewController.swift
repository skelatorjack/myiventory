//
//  DisplayShoppingListItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/24/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import UIKit

enum LabelIndex: Int {
    case Name = 0
    case Quantity = 1
    case Owner = 2
    case Shop = 3
    case Category = 4
}

class DisplayShoppingListItemViewController: UIViewController {

    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var displayImageButton: UIButton!
    
    
    var displayItem: Item = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if displayItem.doesItemHaveImage() {
            displayImageButton.isEnabled = true
        } else {
            displayImageButton.isEnabled = false
        }
        
        setUpLabels()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func setUpLabels() {
        labels.at(index: LabelIndex.Name.rawValue)?.text = getLabel(label: LabelIndex.Name)
        labels.at(index: LabelIndex.Quantity.rawValue)?.text = getLabel(label: LabelIndex.Quantity)
        labels.at(index: LabelIndex.Owner.rawValue)?.text = getLabel(label: LabelIndex.Owner)
        labels.at(index: LabelIndex.Shop.rawValue)?.text = getLabel(label: LabelIndex.Shop)
        labels.at(index: LabelIndex.Category.rawValue)?.text = getLabel(label: LabelIndex.Category)
    }
    
    private func getLabel(label: LabelIndex) -> String {
        var labelText: String = ""
        
        switch label {
        case .Name:
            labelText = "Name: \(displayItem.itemName)"
        case .Quantity:
            labelText = "Quantity: \(displayItem.itemQuantity)"
        case .Owner:
            labelText = "Owner: \(displayItem.itemOwner)"
        case .Shop:
            labelText = "Shop: \(displayItem.shopName)"
        case .Category:
            labelText = "Category: \(displayItem.itemCategory)"
        default:
            labelText = ""
        }
        return labelText
    }
    
}
