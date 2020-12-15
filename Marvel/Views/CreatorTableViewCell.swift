//
//  CreatorTableViewCell.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import UIKit
import SDWebImage

class CreatorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    weak var viewModel: CreatorCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            var url = viewModel.creator.thumbnail.path + "." + viewModel.creator.thumbnail.extension
            if url.contains("image_not_available") {
                creatorImageView.image = UIImage(systemName: "person.fill")!
            } else {
                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                creatorImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "person.fill")!)
            }
            creatorNameLabel.text = viewModel.creator.fullName
        }
    }
}
