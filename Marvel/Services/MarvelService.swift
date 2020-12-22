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
        completion: @escaping ((ItemType?, Error?)) -> Void
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
            switch response.result {
            case .success(let data):
                guard let parsedData = self.parse(data: data, itemType: itemType) else {
                    completion((nil, ApiError.parsingDataError))
                    return
                }
                completion((parsedData, nil))
                
            case .failure(let error):
                completion((nil, ApiError.fetchDataError(err: error.localizedDescription)))
            }
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
