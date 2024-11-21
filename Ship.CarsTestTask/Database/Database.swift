//
//  DatabaseManage.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 15.11.24.
//

import Foundation
import CoreData

class Database: DatabaseProtocol {
    static let shared = Database()
    
    private lazy var container = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Couldn't load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.productFavouriteStateChanged(notification:)), name: .productFavouriteStateChanged, object: nil)
    }
    
    func saveFavouriteProduct(_ product: Product) {
        guard !favouriteProductExists(forId: product.id) else {
            return
        }

        let _ = product.favouriteProduct(context: context)
        do {
            try context.save()
        } catch {
            print("Couldn't save favourite product with id: \(product.id)")
        }
    }
    
    func favouriteProductExists(forId id: Int16) -> Bool {
        let request = FavouriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try context.fetch(request)
            return objects.count > 0
        } catch {
            return false
        }
    }
    
    func getAllFavouriteProducts() -> [Product] {
        let request = FavouriteProduct.fetchRequest()
        guard let result = try? context.fetch(request) else {
            return []
        }
        return result.compactMap{$0.product}
    }
    
    func removeFavouriteProduct(forId id: Int16) {
        let request = FavouriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
                try context.save()
            }
        } catch {
            print("Cannot delete favourite product with id \(id): \(error.localizedDescription)")
        }
    }
    
    @objc func productFavouriteStateChanged(notification: Notification) {
        guard let product = notification.getAttachedProduct() else {
            return
        }
        if product.isFavourite {
            saveFavouriteProduct(product)
            return
        }

        removeFavouriteProduct(forId: product.id)
    }
}
