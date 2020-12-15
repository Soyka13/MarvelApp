//
//  Comics.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import Foundation

struct ComicsData: Codable {
    let data: Comixes
}

struct Comixes: Codable {
    let total: Int
    let results: [Comics]
}

struct Comics: Codable {
    let title: String
    let thumbnail: Thumbnail
    let prices: [ComicsPrice]
}

struct ComicsPrice: Codable {
    let type: String
    let price: Double
}
