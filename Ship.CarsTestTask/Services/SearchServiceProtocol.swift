//
//  SearchServiceProtocol.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 18.11.24.
//

import Foundation

protocol SearchServiceProtocol {
    func search(for text: String) async throws -> [ProductResponse]
}
