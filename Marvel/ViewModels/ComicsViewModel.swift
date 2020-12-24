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
    
    public func modelForCell(with indexPath: IndexPath) -> ItemCellViewModel? {
        guard indexPath.row < comixes.count else {
            return nil
        }
        let comics = comixes[indexPath.row]
        return ItemCellViewModel(item: comics)
    }
    
    public func receiveData(
        _ offset: Int = 0,
        _ limit: Int = 20,
        _ needToCleanData: Bool? = nil,
        completion: @escaping (Bool) -> ()
    ) {
        if let needToCleanData = needToCleanData {
            if needToCleanData {
                comixes.removeAll()
            }
        }
                
        MarvelService.manager.fetch(with: url, offset: offset, limit: limit, itemType: ComicsData.self) { [weak self](comicsData, error) in
            guard let self = self, error == nil, let comicsData = comicsData else {
                print(error ?? "")
                completion(false)
                return
            }
            
            self.totalComixes = comicsData.data.total
            self.comixes.append(contentsOf: comicsData.data.results)
            completion(true)
        }
    }
}
