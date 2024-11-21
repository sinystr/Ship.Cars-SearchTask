//
//  ProductListViewModelProtocol.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

import Foundation

protocol ProductListViewModelProtocol: AnyObject {
    var products: [Product] { get set }
    var productsChangeObserver: (() -> Void)? { get set }
    @MainActor
    func showDetailsForProduct(product: Product)
}
