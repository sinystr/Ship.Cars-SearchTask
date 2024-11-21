//
//  ViewController.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

final class SearchViewController: UIViewController, UISearchBarDelegate {
    static private let waitBeforeSearchTime: TimeInterval = 0.7
    
    // Views
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var productsListContainerView: UIView!
    
    private let viewModel: SearchViewModelProtocol
    private var searchTimer: Timer?
    private weak var productListViewModel: ProductListViewModelProtocol?
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: nil)
        self.viewModel.stateChangeObserver = searchStateChanged
        overrideUserInterfaceStyle = .light
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToolbar()
        addProductsListViewController()
    }
    
    @objc func showFavorites() {
        viewModel.showFavouritesAction()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText, immediately: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchText: searchBar.text ?? "", immediately: true)
        searchBar.endEditing(true)
    }
    
    func searchStateChanged() {
        switch viewModel.searchState {
        case .idle:
            showLoadingView(show: false)
        case .loading:
            showLoadingView(show: true)
        case .loaded(let products):
            showLoadingView(show: false)
            productListViewModel?.products = products
        }
    }
}

private extension SearchViewController {
    func configureToolbar() {
        title = "Search"
        let favouriteBarButtonItem = UIBarButtonItem(image: .favouriteMenuIcon, style: .plain, target: self, action: #selector(showFavorites))

        navigationItem.rightBarButtonItems = [favouriteBarButtonItem]
    }
    
    func showLoadingView(show: Bool) {
        loadingView.isHidden = !show
    }
    
    func addProductsListViewController() {
        let viewModel = ProductListViewModel(parentViewModel: viewModel)
        let childVC = ProductListViewController(viewModel: viewModel)
        productListViewModel = viewModel
        addChild(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = productsListContainerView.bounds
        productsListContainerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    func search(searchText: String, immediately: Bool) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: immediately ? 0.0 : Self.waitBeforeSearchTime, repeats: false, block: {[weak self] _ in
            // Required because viewModel is MainActor isolated
            DispatchQueue.main.async {
                self?.viewModel.searchForProduct(productName: searchText)
            }
        })
    }
}

