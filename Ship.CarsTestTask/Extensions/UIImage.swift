//
//  UIImage.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 18.11.24.
//

import UIKit

extension UIImage {
    static let favouriteSelected = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    static let favouriteUnselected = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let favouriteMenuIcon = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
}
