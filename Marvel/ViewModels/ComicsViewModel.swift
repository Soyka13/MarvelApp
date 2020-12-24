//
//  ComicsViewModel.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import Foundation

class ComicsViewModel {
    
    private var comixes = [Comics]()
    private var totalComixes = 0
    public var url = ""
    
    public var countOfComixes: Int {
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
        
        MarvelService.manager.fetch(
            with: url,
            offset: offset,
            limit: limit,
            itemType: ComicsData.self) { result in
            
            switch result {
            
            case .success(let comixes):
                self.totalComixes = comixes.data.total
                self.comixes.append(contentsOf: comixes.data.results)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
