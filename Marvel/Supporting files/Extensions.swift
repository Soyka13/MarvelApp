//
//  Extensions.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    func downloaded(from url: String) {
        AF.request(url, method: .get).responseImage { (response) in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UIViewController {
    func createSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
