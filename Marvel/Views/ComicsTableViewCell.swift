//
//  ComicsTableViewCell.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import UIKit
import SDWebImage

class ComicsTableViewCell: UITableViewCell {
    @IBOutlet weak var comicsImageView: UIImageView!
    @IBOutlet weak var comicsTitleLabel: UILabel!
    @IBOutlet weak var comicsPriceLabel: UILabel!
    
    weak var viewModel: ComicsCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            var url = viewModel.comics.thumbnail.path + "." + viewModel.comics.thumbnail.extension
            if url.contains("image_not_available") {
                comicsImageView.image = UIImage(systemName: "doc.fill")!
            } else {
                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                comicsImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "doc.fill")!)
            }
            comicsTitleLabel.text = viewModel.comics.title
            comicsPriceLabel.text = String(viewModel.comics.prices[0].price)
        }
    }
}
