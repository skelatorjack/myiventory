//
//  UpdatedItem.swift
//  MyInventory
//
//  Created by Jack Pettit on 5/2/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct UpdatedItem {
    var itemName: String
    var itemOwner: String
    var itemQuantity: Int
    var shoppingListName: String
    var shopName: String
    var itemCategory: ItemCategory
    var hasImage: Bool
    var isInventoryItem: Bool
    var shoppingListId: UUID?
    var itemImage: UIImage?
    init(newItemName: String = "", newItemOwner: String = "", newItemQuantity: Int = 0, newShoppingList: String = "", newShopName: String = "", newItemCategory: ItemCategory = .Other, newHasImage: Bool = false, newIsInventoryItem: Bool = false, newShoppingListId: UUID? = nil, newItemImage: UIImage? = nil) {
        itemName = newItemName
        itemOwner = newItemOwner
        itemQuantity = newItemQuantity
        shoppingListName = newShoppingList
        shopName = newShopName
        itemCategory = newItemCategory
        hasImage = newHasImage
        isInventoryItem = newIsInventoryItem
        shoppingListId = newShoppingListId
    }
    
    mutating func setUpdatedItem(with item: Item, image: UIImage? = nil) {
        itemName = item.itemName
        itemOwner = item.itemOwner
        itemQuantity = item.itemQuantity
        shoppingListName = item.shoppingList
        shopName = item.shopName
        itemCategory = item.itemCategory
        hasImage = item.hasImage
        isInventoryItem = item.isInventoryItem
        shoppingListId = item.shoppingListID
        itemImage = image
    }
    
    func isItemValid(itemType: ItemType) -> Bool {
        switch itemType {
        case .InventoryItem:
            return isInventoryItemValid()
            
        default:
            return isShoppingListItemValid()
        }
    }
    
    func isInventoryItemValid() -> Bool {
        return !itemName.isEmpty && itemQuantity > 0 && !itemOwner.isEmpty
    }
    
    func isShoppingListItemValid() -> Bool {
        return isInventoryItemValid() && !shopName.isEmpty && !shoppingListName.isEmpty
    }
    
    func hasAddedAnImage() -> Bool {
        return self.hasImage && self.itemImage != nil
    }
}
