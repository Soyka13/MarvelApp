//
//  CreatorsViewModel.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import Foundation

class CreatorsViewModel {
    
    private var creators = [Creator]()
    private var totalCreators = 0
    
    public var isAllCreatorsReceived: Bool {
        return creators.count == totalCreators
    }
    
    public var countOfCreators: Int {
        return creators.count
    }
    
    public func modelForCell(with indexPath: IndexPath) -> ItemCellViewModel? {
        guard indexPath.row < creators.count else {
            return nil
        }
        let creator = creators[indexPath.row]
        return ItemCellViewModel(item: creator)
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
        _ name: String? = nil,
        _ needToCleanData: Bool? = nil,
        completion: @escaping (Bool) -> ()
    ) {
        if let needToCleanData = needToCleanData {
            if needToCleanData {
                creators.removeAll()
            }
        }
        
        MarvelService.manager.fetch(
            with: K.urlCreators,
            offset: offset,
            limit: limit,
            name: name
        ) { (result: Result<CreatorsData, ApiError>) in
            
            switch result {
            
            case .success(let creators):
                self.totalCreators = creators.data.total
                self.creators.append(contentsOf: creators.data.results)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
