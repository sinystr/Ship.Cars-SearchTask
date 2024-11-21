//
//  ProductsService.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 21.11.24.
//

import Foundation

protocol ProductsServiceProtocol {
    func getProductsFrom(productsInfo: [ProductResponse]) async -> [Product]
}
