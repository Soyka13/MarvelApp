//
//  Creators.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation

struct CreatorsData: Codable {
    let data: Creators
}

struct Creators: Codable {
    let total: Int
    let results: [CreatorResult]
}

struct CreatorResult: Codable {
    let fullName: String
    let thumbnail: Thumbnail
}
