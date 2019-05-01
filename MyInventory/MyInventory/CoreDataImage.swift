//
//  CoreDataImage.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/30/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreData

enum CoreDataImageKeys: String {
    case itemId
    case imageBinary
}

class CoreDataImage {
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    private var fetchRequest: NSFetchRequest<NSManagedObject>
    private var imagesToSave: [NSManagedObject]
    private let entity: NSEntityDescription
    private var numberOfItemsPersisted: Int = 0
    
    init(appDel: AppDelegate, managedContext: NSManagedObjectContext, fetchReq: NSFetchRequest<NSManagedObject>, imageToSave: [NSManagedObject], entity: NSEntityDescription) {
        self.appDelegate = appDel
        self.managedContext = managedContext
        self.fetchRequest = fetchReq
        self.imagesToSave = imageToSave
        self.entity = entity
    }
    
    func fetchImage(with item: Item) -> UIImage? {
        if item.hasImage {
            let imageData = fetchImageFromCoreData(with: item)
            guard let imageBin = imageData.imageBinary else {
                return nil
            }
            return UIImage(data: imageBin)
        } else {
            return nil
        }
    }
    
    func saveImage(with item: Item, image: UIImage) {
        let imageToSave = NSManagedObject(entity: entity, insertInto: managedContext)
        guard let imageData = getImageData(from: image) else {
            return
        }
        updateImage(coreDataImage: imageToSave, with: item, and: imageData)
        
        do {
            imagesToSave.append(imageToSave)
            try managedContext.save()
        } catch {
            print("Couldn't save shopping list")
        }
    }
    
    func updateImage(coreDataImage: NSManagedObject, with item: Item, and imageData: Data) {
        coreDataImage.setValue(item.itemId.uuidString, forKey: CoreDataImageKeys.itemId.rawValue)
        coreDataImage.setValue(imageData, forKey: CoreDataImageKeys.imageBinary.rawValue)
    }
    
    func fetchImageFromCoreData(with item: Item) -> ImageData {
        var images: [NSManagedObject] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: getImageSearchCriteria(from: item))
        
        do {
            images = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to get image for item with id \(item.itemId.uuidString)")
        }
        
        return images.first as! ImageData
    }
    
    private func getImageSearchCriteria(from item: Item) -> [NSPredicate] {
        return [
            NSPredicate(format: "itemId == %@", item.itemId.uuidString)
        ]
    }
    
    private func getImageData(from image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 1.0)
    }
}
