//
//  Constants.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import Foundation

struct K {
    static let characterCellIdentifier = "CharacterCell"
    static let characterCellNibName = "CharacterTableViewCell"
    static let creatorCellIdentifier = "CreatorCell"
    static let creatorCellNibName = "CreatorTableViewCell"
    static let comicsCellIdentifier = "ComicsCell"
    static let comicsCellNibName = "ComicsTableViewCell"
    
    static let comicsVCNibName = "ComicsViewController"
    
    static let charactersComixSegueIdentifier = "CharactersComixSegue"
    static let creatorsComixSegueIdentifier = "CreatorsComixSegue"
    
    static let urlCharacters = "https://gateway.marvel.com/v1/public/characters?"
    static let urlCreators = "https://gateway.marvel.com/v1/public/creators?"
}
