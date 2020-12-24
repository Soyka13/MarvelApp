//
//  MarvelService.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation
import Alamofire

class MarvelService {
    
    public static let manager = MarvelService()
    
    public func fetch<ItemType: Codable>(
        with url: String,
        offset: Int = 0,
        limit: Int = 20,
        name: String? = nil,
        itemType: ItemType.Type,
        completion: @escaping (Result<ItemType, ApiError>) -> Void
    ) {
        var params : [String: Any] = [
            "apikey" : Keys.PUBLIC_KEY,
            "hash" : Keys.HASH,
            "ts" : 1,
            "offset" : offset,
            "limit" : limit
        ]
        if name != nil {
            params["nameStartsWith"] = name
        }
        
        AF.request(url, method: .get, parameters: params).responseData { (response) in
            
            guard response.error == nil else {
                completion(.failure(.fetchDataError(err: response.error?.localizedDescription ?? "Error fetching data.")))
                return
            }
            
            guard let data = response.data, let parsedData = self.parse(data: data, itemType: itemType) else {
                completion(.failure(.parsingDataError))
                return
            }
            completion(.success(parsedData))
        }
    }
    
    private func parse<ItemType: Codable>(data: Data, itemType: ItemType.Type) -> ItemType? {
        let decoder = JSONDecoder()
        
        if let json = try? decoder.decode(itemType, from: data) {
            return json
        }
        
        return nil
    }
}
