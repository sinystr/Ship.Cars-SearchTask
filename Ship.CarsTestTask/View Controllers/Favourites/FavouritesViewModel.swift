//
//  FavouritesViewModel.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

import Foundation

class FavouritesViewModel: ProductListViewModel {
    init(database: any DatabaseProtocol) {
        super.init(parentViewModel: nil)
        products = database.getAllFavouriteProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(self.productFavouriteStateChanged(notification:)), name: .productFavouriteStateChanged, object: nil)
    }
    
    @objc func productFavouriteStateChanged(notification: Notification) {
        guard let product = notification.getAttachedProduct(), !product.isFavourite else {
            return
        }

        products = products.filter{$0.id != product.id}
    }
}
