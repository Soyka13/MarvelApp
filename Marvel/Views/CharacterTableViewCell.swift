//
//  CharacterTableViewCell.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    
    weak var viewModel: ItemCellViewModel? {
        didSet {
            guard let viewModel = viewModel, let character = viewModel.item as? Character else { return }
            
            var url = character.thumbnail.path + "." + character.thumbnail.extension
            if url.contains("image_not_available") {
                characterImageView.image = UIImage(systemName: "person.fill")!
            } else {
                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                characterImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "person.fill")!)
            }
            characterNameLabel.text = character.name
        }
    }
    
   
}
