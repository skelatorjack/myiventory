//
//  DisplayItemViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/23/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import UIKit

class DisplayItemViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var viewImageButton: UIButton!
    
    var displayItem: Item? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if displayItem!.hasImage {
            viewImageButton.isEnabled = true
        } else {
            viewImageButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
        setItemNameLabel(with: displayItem!.itemName)
        setItemTypeLabel(with: displayItem!.itemCategory)
        setItemQuantityLabel(with: displayItem!.itemQuantity)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let displayItemVC = segue.destination as? DisplayItemImageViewController, displayItem?.itemImage != nil, segue.identifier == Segues.DisplayItemImage.rawValue {
            displayItemVC.image = displayItem!.itemImage
        }
    }
    
    func setItemNameLabel(with name: String) {
        itemNameLabel.text = "Item Name: \(name)"
    }
    
    func setItemQuantityLabel(with quantity: Int) {
        itemQuantityLabel.text = "Item Quantity: \(quantity)"
    }
    
    func setItemTypeLabel(with type: ItemCategory) {
        itemTypeLabel.text = "Item Type: \(type.rawValue)"
    }
    @IBAction func onViewImagePressed(_ sender: Any) {
        print("View Image Pressed")
        performSegue(withIdentifier: Segues.DisplayItemImage.rawValue, sender: nil)
    }
}
