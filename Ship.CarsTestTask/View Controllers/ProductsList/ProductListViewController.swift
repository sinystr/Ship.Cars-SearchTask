//
//  ProductListViewController.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 17.11.24.
//

import UIKit

class ProductListViewController: UICollectionViewController {
    static private let productCellReuseIdentifier = "ProductCollectionViewCell"
    private let viewModel: ProductListViewModelProtocol
    
    private enum Section {
           case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private lazy var dataSource = makeDataSource()
    
    init(viewModel: ProductListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "ProductListViewController", bundle: nil)
        overrideUserInterfaceStyle = .light
        viewModel.productsChangeObserver = self.productsChanged
        applySnapshot(products: viewModel.products)
        self.collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func productsChanged() {
        applySnapshot(products: viewModel.products)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        viewModel.showDetailsForProduct(product: viewModel.products[indexPath.row])
    }
}

private extension ProductListViewController {
    // Declared private, even though extension is private,
    // because of Xcode error
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in

                // 4 display the date in the UI
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Self.productCellReuseIdentifier,
                    for: indexPath) as? ProductCollectionViewCell
                cell?.configure(viewModel: .init(product: item))
                return cell
            })

        return dataSource
    }
    
    func applySnapshot(products: [Product]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let isLandscape = UIDevice.current.orientation.isLandscape
            let columns: CGFloat = isLandscape ? 3 : 1
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / columns),
                                                  heightDimension: .estimated(isLandscape ? 320 : 300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(isLandscape ? 320 : 300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Self.productCellReuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = makeLayout()
        collectionView.delegate = self
    }
}
