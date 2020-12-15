//
//  CreatorsViewModel.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import Foundation

class CreatorsViewModel {
    public var creators = [Creator]()
    public var totalCreators = 0
    
    public var isAllCreatorsReceived: Bool {
        return creators.count == totalCreators
    }
    
    public var countOfCreators: Int {
        return creators.count
    }
    
    public func modelForCell(with indexPath: IndexPath) -> CreatorCellViewModel? {
        guard indexPath.row < creators.count else {
            return nil
        }
        let creator = creators[indexPath.row]
        return CreatorCellViewModel(creator: creator)
    }
    
    public func getComicsViewModelForCreator(with indexPathRow: Int) -> ComicsViewModel? {
        guard indexPathRow < creators.count else {
            return nil
        }
        let comicsViewModel = ComicsViewModel()
        let creator = creators[indexPathRow]
        var url = creator.comics.collectionURI
        url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
        
        comicsViewModel.url = url
        return comicsViewModel
    }
    
    public func receiveData(
        _ offset: Int = 0,
        _ limit: Int = 20,
        _ nameStartsWith: String? = nil,
        _ needToCleanData: Bool? = nil,
        completion: @escaping (Bool) -> ()
    ) {
        if let needToCleanData = needToCleanData {
            if needToCleanData {
                creators.removeAll()
            }
        }
        
        MarvelService.manager.fetchCreatorsData(offset: offset, limit: limit, name: nameStartsWith) { [weak self](creatorsData, error) in
            guard let self = self, error == nil else {
                completion(false)
                return
            }
    
            if let total = creatorsData?.total, let results = creatorsData?.results {
                self.totalCreators = total
                self.creators.append(contentsOf: results)
                completion(true)
            }
        }
    }
}
