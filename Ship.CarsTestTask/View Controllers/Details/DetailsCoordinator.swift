//
//  DetailsCoordinator.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 15.11.24.
//

import UIKit

final class DetailsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    private let product: Product
    
    init(navigationController: UINavigationController, product: Product) {
        self.navigationController = navigationController
        self.product = product
    }
    
    @MainActor
    func start() {
        let viewModel = DetailsViewModel(product: product)
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
