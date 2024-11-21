//
//  ProductCollectionViewCellViewModel.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit
import CoreData

final class Product: Hashable {
    let id: Int16
    let image: UIImage
    let title: String
    let description: String
    var isFavourite: Bool {
        didSet {
            if oldValue != isFavourite {
                let userInfo = ["product": self]
                NotificationCenter.default.post(name: .productFavouriteStateChanged, object: nil, userInfo: userInfo)
            }
        }
    }
    
    init(id: Int16, image: UIImage, title: String, description: String, isFavourite: Bool) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.isFavourite = isFavourite
        NotificationCenter.default.addObserver(self, selector: #selector(self.productFavouriteStateChanged(notification:)), name: .productFavouriteStateChanged, object: nil)

    }
    
    @objc func productFavouriteStateChanged(notification: Notification) {
        guard let product = notification.getAttachedProduct(), product.id == self.id else {
            return
        }
        self.isFavourite = product.isFavourite
    }


    func favouriteProduct(context: NSManagedObjectContext) -> FavouriteProduct {
        let favouriteProduct = FavouriteProduct(context: context)
        favouriteProduct.id = id
        favouriteProduct.image = image.pngData()
        favouriteProduct.title = title
        favouriteProduct.productDescription = description
        return favouriteProduct
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
            return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
