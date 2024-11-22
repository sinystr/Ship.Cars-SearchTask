//
//  ProductCollectionViewCell.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.textContainerInset = .zero
            descriptionTextView.textContainer.lineFragmentPadding = 0
            descriptionTextView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var favouriteButton: UIButton!

    private var viewModel: ProductCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            imageView.image = viewModel.product.image
            titleLabel.text = viewModel.product.title
            descriptionTextView.text = viewModel.product.description
            setFavouriteButtonIcon()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.productFavouriteStateChanged(notification:)), name: .productFavouriteStateChanged, object: nil)
    }
    
    func configure(viewModel: ProductCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func toggleFavourite(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {
            return
        }
        viewModel.product.isFavourite = !viewModel.product.isFavourite
    }
    
    @objc func productFavouriteStateChanged(notification: Notification) {
        guard let product = notification.getAttachedProduct(), product.id == self.viewModel?.product.id else {
            return
        }
        setFavouriteButtonIcon()
    }
}

private extension ProductCollectionViewCell {
    func setFavouriteButtonIcon() {
        guard let product = self.viewModel?.product else {
            return
        }

        if product.isFavourite {
            favouriteButton.setImage(.favouriteSelected, for: .normal)
        } else {
            favouriteButton.setImage(.favouriteUnselected, for: .normal)
        }
    }
}
