//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import Foundation

class ComicsViewModel {
    var comixes = [Comics]()
    var totalComixes = 0
    var url = ""
    
    var countOfComixes: Int {
        return comixes.count
    }
    
    public var isAllComicsReceived: Bool {
        return comixes.count == totalComixes
    }
    
    public func modelForCell(with indexPath: IndexPath) -> ComicsCellViewModel? {
        guard indexPath.row < comixes.count else {
            return nil
        }
        let comics = comixes[indexPath.row]
        return ComicsCellViewModel(comics: comics)
    }
    
    public func receiveData(
        _ offset: Int = 0,
        _ limit: Int = 20,
        _ needToCleanData: Bool? = nil,
        completion: @escaping (Bool) -> ()
    ) {
        // bad part - need to fix that
        if let needToCleanData = needToCleanData {
            if needToCleanData {
                comixes.removeAll()
            }
        }
        
        MarvelService.manager.fetchComicsData(with: url, offset: offset, limit: limit) { [weak self](comicsData, error) in
            guard let self = self, error == nil else {
                completion(false)
                return
            }
    
            if let total = comicsData?.total, let results = comicsData?.results {
                self.totalComixes = total
                self.comixes.append(contentsOf: results)
                completion(true)
            }
        }
    }
}
