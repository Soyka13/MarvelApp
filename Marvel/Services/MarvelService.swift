//
//  MarvelService.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation
import Alamofire

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
                    completion((nil, ApiError.fetchCharacterError))
                    return
                }
                completion((characters, nil))
            case .failure(let error):
                print(error.localizedDescription)
                completion((nil, ApiError.fetchCharacterError))
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
                    completion((nil, ApiError.fetchCreatorError))
                    return
                }
                completion((creators, nil))
            case .failure(let error):
                print(error.localizedDescription)
                completion((nil, ApiError.fetchCreatorError))
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
    
    public func fetchComicsData(
        with url: String,
        offset: Int = 0,
        limit: Int = 20,
        completion: @escaping ((Comixes?, Error?)) -> Void
    ) {
        let params : [String: Any] = [
            "apikey" : Keys.PUBLIC_KEY,
            "hash" : Keys.HASH,
            "ts" : 1,
            "offset" : offset,
            "limit" : limit
        ]
        
        AF.request(url, method: .get, parameters: params).responseData { (response) in
            switch response.result {
            case .success(let data):
                let comixes = self.parseComics(data: data)
                guard comixes != nil else {
                    completion((nil, ApiError.fetchComicsError))
                    return
                }
                completion((comixes, nil))
            case .failure(let error):
                print(error.localizedDescription)
                completion((nil, ApiError.fetchComicsError))
            }
        }
    }
    
    private func parseComics(data: Data) -> Comixes? {
        let decoder = JSONDecoder()
        
        if let comixesJSON = try? decoder.decode(ComicsData.self, from: data) {
            return comixesJSON.data
        }
        
        return nil
    }
}
