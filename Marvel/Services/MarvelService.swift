//
//  MarvelService.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation
import Alamofire
import AlamofireImage

class MarvelService {
    private let urlCharacters = "https://gateway.marvel.com/v1/public/characters?"
    
    private let urlCreators = "https://gateway.marvel.com/v1/public/creators?"
    
    public static let manager = MarvelService()
    
    public func fetchCharactersData(
        offset: Int = 0,
        limit: Int = 20,
        name: String? = nil,
        completion: @escaping ((Characters?, Error?)) -> Void
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
        
        AF.request(urlCharacters,
                   method: .get,
                   parameters: params).responseData { [weak self](response) in
            guard let self = self else {
                return
            }
            switch response.result {
        
            case .success(let data):
                let characters = self.parseCharacter(data: data)
                guard characters != nil else {
                    completion((nil, ApiError.characterError))
                    return
                }
                completion((characters, nil))
            case .failure(let error):
                print(error.localizedDescription)
                completion((nil, ApiError.characterError))
            }
        }
    }
    
    private func parseCharacter(data: Data) -> Characters? {
        let decoder = JSONDecoder()
        
        if let charactersJSON = try? decoder.decode(CharactersData.self, from: data) {
            return charactersJSON.data
        }
        
        return nil
    }
    
    public func fetchCreatorsData(
        pagination: Bool = false,
        offset: Int = 0,
        limit: Int = 20,
        name: String? = nil,
        completion: @escaping ((Creators?, Error?)) -> Void
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
        
        AF.request(urlCreators, method: .get, parameters: params).responseData { [weak self](response) in
            guard let self = self else {
                return
            }
            switch response.result {

            case .success(let data):
                let creators = self.parseCreators(data: data)
                guard creators != nil else {
                    completion((nil, ApiError.creatorError))
                    return
                }
                completion((creators, nil))
            case .failure(let error):
                print(error.localizedDescription)
                completion((nil, ApiError.creatorError))
            }
        }
    }
      
    private func parseCreators(data: Data) -> Creators? {
        let decoder = JSONDecoder()
        
        if let creatorsJSON = try? decoder.decode(CreatorsData.self, from: data) {
            return creatorsJSON.data
        }
        
        return nil
    }
}
