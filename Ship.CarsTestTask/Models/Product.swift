//
//  ProductCollectionViewCellViewModel.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import CoreData
import UIKit

/// Product model that is the main model of the application,
/// represents a product with downloaded image
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
                favouriteStateChangedObserver?()
            }
        }
    }

    var favouriteStateChangedObserver: (() -> Void)?
    
    init(id: Int16, image: UIImage, title: String, description: String, isFavourite: Bool) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.isFavourite = isFavourite
        NotificationCenter.default.addObserver(self, selector: #selector(self.productFavouriteStateChanged(notification:)), name: .productFavouriteStateChanged, object: nil)

    }
    
    convenience init?(with favouriteProduct: FavouriteProduct) {
        guard let imageData = favouriteProduct.image,
              let image = UIImage(data: imageData),
              let productDescription = favouriteProduct.productDescription,
              let title = favouriteProduct.title else {
            return nil
        }
            
        self.init(id: favouriteProduct.id, image: image, title: title, description: productDescription, isFavourite: true)
    }
    
    @objc func productFavouriteStateChanged(notification: Notification) {
        guard let product = notification.getAttachedProduct(),
              product.id == self.id else {
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
    

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
