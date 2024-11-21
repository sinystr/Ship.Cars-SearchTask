//
//  NSNotification.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 18.11.24.
//

import Foundation

extension Notification {
    func getAttachedProduct() -> Product? {
        guard let product = self.userInfo?["product"] as? Product else {
            return nil
        }

        return product
    }
}
