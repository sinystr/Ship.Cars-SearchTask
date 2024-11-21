//
//  ProductResponse.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

struct ProductResponse: Decodable {
    let id: Int16
    let title: String
    let description: String
    let thumbnail: String
    
    func productWithImage(image: UIImage, andFavouriteStatus favoruite: Bool) -> Product {
        return .init(id: self.id, image: image, title: self.title, description: self.description, isFavourite: favoruite)
    }
}
