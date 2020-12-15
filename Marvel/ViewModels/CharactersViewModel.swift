//
//  MarvelViewModel.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation

class CharactersViewModel {
    
    public var characters = [Character]()
    
    public var totalCharacters = 0
    
    public var isAllCharactersReceived: Bool {
        return characters.count == totalCharacters
    }
    
    public var countOfCharacters: Int {
        return characters.count
    }
    
    public func modelForCell(with indexPath: IndexPath) -> CharacterCellViewModel? {
        guard indexPath.row < characters.count else {
            return nil
        }
        let character = characters[indexPath.row]
        return CharacterCellViewModel(character: character)
    }
    
    public func getComicsViewModelForCharacter(with indexPathRow: Int) -> ComicsViewModel? {
        guard indexPathRow < characters.count else {
            return nil
        }
        let comicsViewModel = ComicsViewModel()
        let character = characters[indexPathRow]
        var url = character.comics.collectionURI
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
        // bad part - need to fix that
        if let needToCleanData = needToCleanData {
            if needToCleanData {
                characters.removeAll()
            }
        }
        
        MarvelService.manager.fetchCharactersData(offset: offset, limit: limit, name: nameStartsWith) { [weak self](charactersData, error) in
            guard let self = self, error == nil else {
                completion(false)
                return
            }
    
            if let total = charactersData?.total, let results = charactersData?.results {
                self.totalCharacters = total
                self.characters.append(contentsOf: results)
                completion(true)
            }
        }
    }
}
