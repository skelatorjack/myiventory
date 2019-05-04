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
        print("The number of images in core data is \(fetchAllImagesFromCoreData())")
        //deleteAllImages()
    }
    
    func fetchImage(with item: Item) -> UIImage? {
        if item.hasImage {
            let imageData = fetchImageFromCoreData(with: item).first
            guard let imageBin = imageData?.imageBinary else {
                return nil
            }
            return UIImage(data: imageBin)
        } else {
            return nil
        }
    }
    
    func fetchImage(with uuid: UUID) -> UIImage? {
        let item: Item = Item(newItemId: uuid, hasImage: true)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: getImageSearchCriteria(from: item))
        return fetchImage(with: item)
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
    
    func updateItemImage(item: Item, image: UIImage) {
        let searchCriteria = getImageSearchCriteria(from: item)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            let images = try managedContext.fetch(fetchRequest)
            guard let imageData = getImageData(from: image), let firstImage = images.first else {
                return
            }
            updateImage(coreDataImage: firstImage, with: item, and: imageData)
            try managedContext.save()
        } catch {
            print("Couldn't save image. \(error)")
        }
    }
    func updateImage(coreDataImage: NSManagedObject, with item: Item, and imageData: Data) {
        coreDataImage.setValue(item.itemId.uuidString, forKey: CoreDataImageKeys.itemId.rawValue)
        coreDataImage.setValue(imageData, forKey: CoreDataImageKeys.imageBinary.rawValue)
    }
    
    func fetchImageFromCoreData(with item: Item) -> [ImageData] {
        var images: [NSManagedObject] = []
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: getImageSearchCriteria(from: item))
        
        do {
            images = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to get image for item with id \(item.itemId.uuidString)")
        }
        
        return images as! [ImageData]
    }
    
    func fetchAllImagesFromCoreData() -> Int {
        let searchCriteria: [NSPredicate] = []
        var imageCount: Int = 0
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                imageCount = result.count
            }
        }
        return imageCount
    }
    private func getImageSearchCriteria(from item: Item) -> [NSPredicate] {
        return [
            NSPredicate(format: "itemId == %@", item.itemId.uuidString)
        ]
    }
    
    private func getImageIdSearchCriteria(from id: UUID) -> Array<NSPredicate> {
        return [NSPredicate(format: "itemId == %@", id.uuidString)]
    }
    
    private func getImageData(from image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 1.0)
    }
    
    func deleteImage(with item: Item) {
        let searchCriteria: [NSPredicate] = getImageSearchCriteria(from: item)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest), let firstImage = result.first {
                managedContext.delete(firstImage)
                try managedContext.save()
            }
        } catch {
            print("Failed to delete image \(error)")
        }
    }
    
    private func deleteAllImages() {
        let searchCriteria: [NSPredicate] = []
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchCriteria)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for image in result {
                     managedContext.delete(image)
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to delete image \(error)")
        }
    }
}
