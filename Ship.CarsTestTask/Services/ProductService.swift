//
//  ProductService.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 21.11.24.
//

import UIKit


/// Service class used to convert ``ProductResponse`` to ``Product``
final class ProductService: ProductsServiceProtocol {
    static let requestCanceledCode: Int16 = -999
    let database: DatabaseProtocol
    
    init(database: DatabaseProtocol) {
        self.database = database
    }
    
    /// Async function that converts ``ProductResponse`` to ``Product``, fetching each thumbnail from ``ProductResponse``
    func getProductsFrom(productsInfo: [ProductResponse]) async -> [Product] {
        do {
            return try await withThrowingTaskGroup(of: Product.self) { group in
                var returnProducts: [Product] = []
                returnProducts.reserveCapacity(productsInfo.count)
                
                productsInfo.forEach {
                    let product = $0
                    
                    group.addTask {
                        if let url = URL(string: product.thumbnail),
                           let data = try? Data(contentsOf: url),
                           let image = UIImage(data: data) {
                            return product.productWithImage(image: image, andFavouriteStatus: self.database.favouriteProductExists(forId: product.id))
                        }
                        return product.productWithImage(image: UIImage(), andFavouriteStatus: Config.defaultDatabase.favouriteProductExists(forId: product.id))
                    }
                }
                
                for try await product in group {
                    returnProducts.append(product)
                }
                
                returnProducts = returnProducts.sorted{ $0.id < $1.id }
                
                return returnProducts
            }
        } catch {
            guard error._code != Self.requestCanceledCode else {
                return []
            }
            print(error)
        }
        return []
    }
}
