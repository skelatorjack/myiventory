//
//  UserTests.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/7/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import XCTest
@testable import MyInventory

class UserTests: XCTestCase {
    var testUser: User!
    let testItem: Item = Item(newId: 1, newName: "TP", newOwner: "Jack", newQuantity: 1)
    let emptyString: String = ""
    let unInitializedVal: Int = -1
    
    override func setUp() {
        super.setUp()
        testUser = User()
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func test_whenUserIsInitializedItemListisEmpty() {
        XCTAssertEqual(testUser.getItemCount(), 0)
    }
    
    func test_whenItemIsSaved_itemIsThere() {
        
        testUser.add(item: testItem)
        
        XCTAssert(testUser.getItemCount() > 0)
        
        let actualItem = testUser.item(at: 0)
        
        XCTAssertNotNil(actualItem)
        XCTAssertTrue(areItemsEqual(left: actualItem!, right: testItem))
    }
    
    func areItemsEqual(left: Item, right: Item) -> Bool {
        if left.itemName == right.itemName,
            left.itemId == right.itemId,
            left.itemOwner == right.itemOwner,
            left.itemQuantity == right.itemQuantity {
            
            return true
        }
        return false
    }
    
    func test_whenItemIsSaved_ItemIsReturnedAtIndex() {
        testUser.add(item: testItem)
        
        XCTAssert(testUser.getItemCount() > 0)
        XCTAssertTrue(areItemsEqual(left: testUser.item(at: 0)!, right: testItem))
    }
    
    func test_whenItemIsCalledAtInvalidIndex_ReturnNil() {
        
        XCTAssertNil(testUser.item(at: 0))
        XCTAssertNil(testUser.item(at: -1))
        XCTAssertNil(testUser.item(at: 25))
    }
    
    func whenItemValid_trueIsReturned() {
        
        XCTAssertTrue(testItem.isItemValid())
    }
    
    func whenItemIsNotValid_falseIsReturned() {
        
        // All not valid
        var item: Item = Item()
        item.itemQuantity = -1
        
        XCTAssertFalse(item.isItemValid())
        
        // Quantity is only true
        item = Item()
        item.itemQuantity = 1
        
        XCTAssertFalse(item.isItemValid())
        
        // Owner is only true
        item = Item()
        item.itemQuantity = -1
        item.itemOwner = "Jack"
        
        XCTAssertFalse(item.isItemValid())
        
        // Name is only true
        item = Item()
        item.itemName = "Toothpaste"
        item.itemQuantity = -1
        
        XCTAssertFalse(item.isItemValid())
        
        // Only name is false
        item = Item()
        item.itemOwner = "Jack"
        
        XCTAssertFalse(item.isItemValid())
        
        // Only owner is false
        item = Item()
        
        XCTAssertFalse(item.isItemValid())
        
        // Only quantity is false
        item = Item()
        item.itemName = "Toothpaste"
        item.itemOwner = "Jack"
        item.itemQuantity = -1
        
        XCTAssertFalse(item.isItemValid())
    }
    
    func test_whenItemIsUpdated_ItemIsDifferent() {
        testUser.add(item: testItem)
        
        let updateItem: Item = Item(newId: 1, newName: "Toothpaste", newOwner: "Jack", newQuantity: 2)
        XCTAssertTrue(!testUser.isListEmpty())
        
        testUser.updateItem(at: 0, with: updateItem)
        
        XCTAssertNotEqual(testUser.item(at: 0), testItem)
        
    }
    
    func test_whenItemIsCleared_EverythingIsDefualt() {
        
        var item: Item = testItem
        
        item.clear()
        
        XCTAssertEqual(item.itemName, "")
        XCTAssertEqual(item.itemOwner, "")
        XCTAssertEqual(item.itemQuantity, -1)
        XCTAssertEqual(item.itemId, -1)
    }
    
    func test_whenNoItemInList_isListEmptyReturnsTrue() {
        XCTAssertTrue(testUser.isListEmpty())
    }
    
    func test_whenItemisInList_isListEmptyReturnsFalse() {
        testUser.add(item: testItem)
        XCTAssertFalse(testUser.isListEmpty())
    }
    
    func test_whenItemisUpdatedWithSameData_ItemsAreEqual() {
        testUser.add(item: testItem)
        testUser.updateItem(at: 0, with: testItem)
        
        XCTAssertNotNil(testUser.item(at: 0))
        XCTAssertEqual(testUser.item(at: 0), testItem)
    }
    
}
