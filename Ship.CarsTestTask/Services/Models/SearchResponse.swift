//
//  SearchResponse.swift
//  Ship.CarsTestTask
//
//  Created by Georgi Georgiev on 14.11.24.
//

struct SearchResponse: Decodable {
    let products: [ProductResponse]
}
