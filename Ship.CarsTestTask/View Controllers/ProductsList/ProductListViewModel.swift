//
//  ProductListViewModel.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

class ProductListViewModel: ProductListViewModelProtocol {
    let parentViewModel: SearchViewModelProtocol?

    var products: [Product] = []
    {
        didSet {
            productsChangeObserver?()
        }
    }

    var productsChangeObserver: (() -> Void)?
    
    init(parentViewModel: SearchViewModelProtocol?) {
        self.parentViewModel = parentViewModel
    }
    
    @MainActor
    func showDetailsForProduct(product: Product) {
        parentViewModel?.showDetailsForProduct(product: product)
    }
}
