//
//  Coordinator.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    @MainActor
    func start()
}

extension Coordinator {
    func childDidFinish<T: Coordinator>(_ type: T.Type) {
        guard let index = childCoordinators.firstIndex(where: { $0 is T }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
}
