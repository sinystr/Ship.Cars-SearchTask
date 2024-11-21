//
//  FavouritesViewController.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

import UIKit

class FavouritesViewController: ProductListViewController {
    static let title = "Favourites"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Self.title
        overrideUserInterfaceStyle = .light
    }
}
