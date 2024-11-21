//
//  FavouritesCoordinator.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

import UIKit

class FavouritesCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    private let database: any DatabaseProtocol
    
    init(navigationController: UINavigationController,
         database: any DatabaseProtocol) {
        self.navigationController = navigationController
        self.database = database
    }
    
    func start() {
        let viewModel = FavouritesViewModel(database: Config.defaultDatabase)
        let viewController = FavouritesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
