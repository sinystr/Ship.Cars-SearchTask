//
//  SearchService.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

import Foundation

/// Service class used to fetch search results in the of array of ``ProductResponse``
final class SearchService: SearchServiceProtocol {
    static let searchURL: String = "https://dummyjson.com/products/search"
    
    /// Async function that fetches the``ProductResponse`` array of results
    func search(for text: String) async throws -> [ProductResponse] {
        var urlComponents = URLComponents(string: Self.searchURL)!

        let parameters: [String: String] = [
            "q": text
        ]

        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let productsResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return productsResponse.products
    }
}
