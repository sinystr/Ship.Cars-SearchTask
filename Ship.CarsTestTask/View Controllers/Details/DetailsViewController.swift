//
//  DetailsViewController.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 15.11.24.
//

import UIKit

class DetailsViewController: UIViewController {
    private let viewModel: DetailsViewModel
    
    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet private var favouriteButton: UIButton!
    @IBOutlet private var productImage: UIImageView!
    @IBOutlet private var productTitleLabel: UILabel!
    @IBOutlet private var productDescriptionTextView: UITextView! {
        didSet {
            productDescriptionTextView.textContainerInset = .zero
            productDescriptionTextView.textContainer.lineFragmentPadding = 0
        }
    }

    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = viewModel.product.image
        productTitleLabel.text = viewModel.product.title
        productDescriptionTextView.text = viewModel.product.description
        configureStackViewOrientation()
        setFavouriteButtonIcon()
        edgesForExtendedLayout = []
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        configureStackViewOrientation()
    }
    
    @IBAction func toggleFavourite(_ sender: UIButton) {
        viewModel.product.isFavourite = !viewModel.product.isFavourite
        setFavouriteButtonIcon()
    }
}

private extension DetailsViewController {
    func configureStackViewOrientation() {
        let isLandscape = UIDevice.current.orientation.isLandscape
        containerStackView.axis = isLandscape ? .horizontal : .vertical
        containerStackView.alignment = isLandscape ? .center : .fill
    }
    
    func setFavouriteButtonIcon() {
        if viewModel.product.isFavourite {
            favouriteButton.setImage(.favouriteSelected, for: .normal)
        } else {
            favouriteButton.setImage(.favouriteUnselected, for: .normal)
        }
    }
}
