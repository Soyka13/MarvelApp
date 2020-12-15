//
//  CharacterTableViewCell.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    
    weak var viewModel: CharacterCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            var url = viewModel.character.thumbnail.path + "." + viewModel.character.thumbnail.extension
            if url.contains("image_not_available") {
                characterImageView.image = UIImage(systemName: "person.fill")!
            } else {
                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                characterImageView.downloaded(from: url)
//                characterImageView.downloadImage(from: url)
            }
            characterNameLabel.text = viewModel.character.name
        }
    }
    
   
}
