//
//  SearchViewModelProtocol.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

enum SearchState {
    case idle, loading, loaded([Product])
}

@MainActor
protocol SearchViewModelProtocol: AnyObject {
    var searchState: SearchState { get }
    var stateChangeObserver: (() -> Void)? { set get }
    
    func searchForProduct(productName: String)
    func showDetailsForProduct(product: Product)
    func showFavouritesAction()
}
