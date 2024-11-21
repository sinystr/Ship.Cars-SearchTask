//
//  SearchViewModel.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

@MainActor
final class SearchViewModel: SearchViewModelProtocol {
    private let coordinator: SearchCoordinator
    private(set) var searchState: SearchState = .idle
    {
        didSet {
            stateChangeObserver?()
        }
    }
    var stateChangeObserver: (() -> Void)?
    
    private let searchService: SearchServiceProtocol
    private let productsService: ProductsServiceProtocol
    private var currentTask: Task<(), Never>?
    private let database: DatabaseProtocol
    
    init(searchService: SearchServiceProtocol,
         database: DatabaseProtocol,
         coordinator: SearchCoordinator,
         productsService: ProductsServiceProtocol) {
        self.searchService = searchService
        self.coordinator = coordinator
        self.database = database
        self.productsService = productsService
    }
    
    func searchForProduct(productName: String) {
        currentTask?.cancel()
        
        guard !productName.isEmpty else {
            searchState = .loaded([])
            return
        }

        self.searchState = .loading

        currentTask = Task {
            do {
                let products = try await searchService.search(searchText: productName)
                self.searchState = .loaded(await productsService.getProductsFrom(productsInfo: products))
            } catch {
                print("Error while fething products: \(error)")
            }
        }
    }
    
    func showDetailsForProduct(product: Product) {
        coordinator.showDetailsForProduct(product: product)
    }
    
    func showFavouritesAction() {
        coordinator.showFavourites()
    }
}
