//
//  UserTests.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/7/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import XCTest
import CoreData
@testable import MyInventory

class UserTests: XCTestCase {
    var testUser: User!
    let testItem: Item = Item(newName: "TP", newOwner: "Jack", newQuantity: 1)
    let emptyString: String = ""
    let unInitializedVal: Int = -1

    override func setUp() {
        super.setUp()
        testUser = User(appDel: (UIApplication.shared.delegate as? AppDelegate)!)
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func deleteAfterTest(item: Item) {
        if let indexOfItem = testUser.getIndexOfItem(itemToFind: item) {
            testUser.delete(at: indexOfItem)
        }
    }
    
    func addAfterTest(item: Item) {
        testUser.add(item: item)
    }
    
    func restoreAfterTest(oldItem: Item, at index: Int) {
        testUser.updateItem(at: index, with: oldItem)
    }
    
    func test_whenUserIsInitializedItemListisEmpty() {
        XCTAssertTrue(testUser.isListEmpty())
    }
    
    func test_whenItemIsSaved_itemIsThere() {
        
        testUser.add(item: testItem)
        
        XCTAssert(testUser.getItemCount() > 0)
        
        let actualItem = testUser.item(at: 0)
        
        XCTAssertNotNil(actualItem)
        XCTAssertFalse(testUser.isListEmpty())
    
        deleteAfterTest(item: testItem)
    }
    
    func test_whenItemIsSaved_ItemIsReturnedAtIndex() {
        testUser.add(item: testItem)
        
        XCTAssert(testUser.getItemCount() > 0)
        XCTAssertEqual(testUser.item(at: 0), testItem)
        
        deleteAfterTest(item: testItem)
    }
    
    func test_whenItemIsCalledAtInvalidIndex_ReturnNil() {
        
        XCTAssertNil(testUser.item(at: 0))
        XCTAssertNil(testUser.item(at: -1))
        XCTAssertNil(testUser.item(at: 25))
    }
    
    func test_whenItemIsCalledAtValidIndex_NilIsNotReturned() {
        testUser.add(item: testItem)
        
        XCTAssertNotNil(testUser.item(at: 0))
        
        deleteAfterTest(item: testItem)
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
        
        let updateItem: Item = Item(newName: "Toothpaste", newOwner: "Jack", newQuantity: 2)
        XCTAssertTrue(!testUser.isListEmpty())
        
        testUser.updateItem(at: 0, with: updateItem)
        
        XCTAssertNotEqual(testUser.item(at: 0), testItem)
        
        deleteAfterTest(item: updateItem)
        
    }
    
    func test_whenItemIsCleared_EverythingIsDefualt() {
        
        var item: Item = testItem
        
        item.clear()
        
        XCTAssertEqual(item.itemName, "")
        XCTAssertEqual(item.itemOwner, "")
        XCTAssertEqual(item.itemQuantity, -1)
    }
    
    func test_whenNoItemInList_isListEmptyReturnsTrue() {
        XCTAssertTrue(testUser.isListEmpty())
    }
    
    func test_whenItemisInList_isListEmptyReturnsFalse() {
        testUser.add(item: testItem)
        XCTAssertFalse(testUser.isListEmpty())
        deleteAfterTest(item: testItem)
    }
    
    func test_whenItemisUpdatedWithSameData_ItemsAreEqual() {
        testUser.add(item: testItem)
        testUser.updateItem(at: 0, with: testItem)
    
        XCTAssertNotNil(testUser.item(at: 0))
        XCTAssertEqual(testUser.item(at: 0), testItem)
        deleteAfterTest(item: testItem)
    }
    
    
    func test_whenItemIsUpdatedAtInvalidIndex_ListIsNotUpdated() {
    
        testUser.add(item: testItem)
        let item: Item = Item(newName: "Toothpaste", newOwner: "Jack", newQuantity: 1)
        
        testUser.updateItem(at: 1, with: item)
        
        XCTAssertFalse(testUser.isItemInList(item: item))
        XCTAssertEqual(testUser.getItemCount(), 1)
        deleteAfterTest(item: testItem)
    }
    
    // Delete tests
    
    func test_whenItemIsDeletedAtValidIndex_ListIsEmpty() {
        testUser.add(item: testItem)
        
        XCTAssertFalse(testUser.isListEmpty())
        
        testUser.delete(at: 0)
        
        XCTAssertTrue(testUser.isListEmpty())
    }
    
    func test_whenItemIsDeletedAtInvalidIndex_ListIsNotUpdated() {
        testUser.add(item: testItem)
        
        let LISTCOUNT = testUser.getItemCount()
        
        testUser.delete(at: 1)
        
        XCTAssertEqual(testUser.getItemCount(), LISTCOUNT)
        deleteAfterTest(item: testItem)
    }
    
    func test_whenItemIsDeleted_ItemIsNotInList() {
        testUser.add(item: testItem)
    
        let count = testUser.getItemCount()
        testUser.delete(at: 0)
        
        XCTAssertFalse(testUser.isItemInList(item: testItem))
        XCTAssertLessThan(testUser.getItemCount(), count)
        
    }
    // Core Data Tests
    func test_didFetchDataFromCoreData() {
        
        var itemCountFromFetch: Int = 0
        
        testUser.fetchFromCoreData()
        
        itemCountFromFetch = testUser.getNumberOfItemsFromCoreData()
        
        XCTAssertFalse(testUser.isListEmpty())
        XCTAssertEqual(testUser.getItemCount(), itemCountFromFetch)

    }
    
    func test_whenListIsNotEmptyAndCoreDataListIsEmpty_DonotSetItemList() {
        let emptyItems: [ItemModel] = []
        
        testUser.add(item: testItem)
        testUser.adaptItemModelToItemList(itemModels: emptyItems)
        
        XCTAssertFalse(testUser.isListEmpty())
        XCTAssertTrue(testUser.getItemCount() == 1)
        
        deleteAfterTest(item: testItem)
    }
    
    func test_whenListIsNotEmptyAndCoreDataListIsNotEmpty_DonotSetItemList() {
        
        testUser.add(item: testItem)
        
    }
    
    func test_whenListIsEmptyAndCoreDataListIsEmpty_DonotSetItemList() {
        let emptyItems: [ItemModel] = []
        
        testUser.adaptItemModelToItemList(itemModels: emptyItems)
        
        XCTAssertTrue(testUser.isListEmpty())
    }
    
    func test_whenListIsEmptyAndCoreDataListIsNotEmpty_DoSetItemList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ItemModel")
        
        
        do {
            let items = try managedContext.fetch(fetchRequest) as! [ItemModel]
            testUser.adaptItemModelToItemList(itemModels: items)
        } catch let error as NSError {
            print("Can't fetch data \(error)")
        }
        
        XCTAssertFalse(testUser.isListEmpty())
    }
}
