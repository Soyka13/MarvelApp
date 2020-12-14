//
//  Characters.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation

struct CharactersData: Codable {
    let data: Characters
}

struct Characters: Codable {
    let total: Int
    let results: [Character]
}

struct Character: Codable {
    let name: String
    let thumbnail: Thumbnail
}
