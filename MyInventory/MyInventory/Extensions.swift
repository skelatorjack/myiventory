//
//  Extensions.swift
//  MyInventory
//
//  Created by Jack Pettit on 8/24/17.
//  Copyright © 2017 jpettit. All rights reserved.
//

import Foundation
import UIKit
// get element at index

extension Array {
    func at(index: Int) -> Element? {
        if (index < 0 || index >= self.count) {
            return nil
        }
        return self[index]
    }
    func first() -> Element? {
        if self.count > 0 {
            return self.first
        }
        return nil
    }
    func last() -> Element? {
        if self.count > 0 {
            return self.last
        }
        return nil
    }
}

extension UIImage {
    func isEqual(to image: UIImage) -> Bool {
        guard let imageData = self.jpegData(compressionQuality: 1.0), let imageData2 = image.jpegData(compressionQuality: 1.0) else {
            return false
        }
        return imageData == imageData2
    }
}

