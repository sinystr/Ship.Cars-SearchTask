//
//  FavouriteProduct+CoreDataProperties.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 16.11.24.
//
//

import Foundation
import CoreData
import UIKit


extension FavouriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteProduct> {
        return NSFetchRequest<FavouriteProduct>(entityName: "FavouriteProduct")
    }

    @NSManaged public var id: Int16
    @NSManaged public var image: Data?
    @NSManaged public var productDescription: String?
    @NSManaged public var title: String?

}

extension FavouriteProduct : Identifiable {

}
