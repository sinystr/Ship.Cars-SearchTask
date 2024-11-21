//
//  DatabaseProtocol.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 16.11.24.
//

import Foundation

protocol DatabaseProtocol: AnyObject {
    func saveFavouriteProduct(_ product: Product)
    func favouriteProductExists(forId id: Int16) -> Bool
    func getAllFavouriteProducts() -> [Product]
    func removeFavouriteProduct(forId id: Int16)
}
