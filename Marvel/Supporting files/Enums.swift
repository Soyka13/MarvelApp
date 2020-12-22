//
//  Enums.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation

enum ApiError: Error {
    case fetchDataError(err: String)
    case parsingDataError
}
