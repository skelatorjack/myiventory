//
//  ImageData+CoreDataProperties.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/30/19.
//  Copyright © 2019 jpettit. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var itemId: String?
    @NSManaged public var imageBinary: NSData?

}
