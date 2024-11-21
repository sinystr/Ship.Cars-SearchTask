//
//  SearchCoordinator.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

final class SearchCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }
    
    @MainActor
    func start() {
        let viewModel = SearchViewModel(searchService: SearchService(), database: Config.defaultDatabase, coordinator: self, productsService: ProductService(database: Config.defaultDatabase))
        let viewController = SearchViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @MainActor
    func showDetailsForProduct(product: Product) {
        let coordinator = DetailsCoordinator(navigationController: navigationController, product: product)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    @MainActor
    func showFavourites(){
        let coordinator = FavouritesCoordinator(navigationController: navigationController, database: Config.defaultDatabase)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension SearchCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let _ = fromVC as? FavouritesViewController {
            childDidFinish(FavouritesCoordinator.self)
        }
        
        if let _ = fromVC as? DetailsViewController {
            childDidFinish(DetailsCoordinator.self)
        }
    }
}
