//
//  Enumerations.swift
//  MyInventory
//
//  Created by Jack Pettit on 1/7/18.
//  Copyright © 2018 jpettit. All rights reserved.
//

import Foundation

enum TypeOfAssign {
    case String
    case Int
}

enum ItemCategory: String {
    case Food = "Food"
    case Tech = "Tech"
    case Cleaning = "Cleaning"
    case Clothes = "Clothes"
    case Fashion = "Fashion"
    case Tools = "Tools"
    case Yard = "Yard"
    case Other = "Other"
}

enum Segues: String {
    case AddImage = "addImageSegue"
    case AddImageFromUpdate = "addImageSegueFromUpdate"
    case DisplayItemItemList = "displayItemItemList"
    case DisplayItemShoppingList = "displayItemShoppingList"
    case DisplayItemImage = "displayItemImage"
    case AddImageFromShoppingList = "addImageSegueFromAddItemShopList"
    case DisplayShoppingListItemImage = "displayShoppingListItemImage"
    case AddImageFromUpdateShoppingListItem = "addImageFromUpdateShoppingListItem"
}
