//
//  ComicsViewController.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import UIKit
import Lightbox

class ComicsViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
        
        var comicsViewModel: ComicsViewModel?
        
        public var isLoading = false

        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: K.comicsCellNibName, bundle: nil), forCellReuseIdentifier: K.comicsCellIdentifier)
            loadData()
        }
        
        private func loadData(
            offset: Int = 0,
            limit: Int = 20,
            needToCleanData: Bool? = nil
        ) {
            isLoading = true
            comicsViewModel?.receiveData(offset, limit, needToCleanData, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
                self.isLoading = false
            })
        }
    
    private func initializeImageViewer(images: [LightboxImage]) {
        let imageViewer = LightboxController(images: images)
        imageViewer.pageDelegate = self
        imageViewer.dismissalDelegate = self
        imageViewer.dynamicBackground = true

        present(imageViewer, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension ComicsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicsViewModel?.countOfComixes ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comicsViewModel = comicsViewModel else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.comicsCellIdentifier, for: indexPath) as! ComicsTableViewCell
        cell.viewModel = comicsViewModel.modelForCell(with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ComicsTableViewCell
//        if cell.comicsImageView.image == UIImage(systemName: "doc.fill") { return }
        let images = [LightboxImage(image: cell.comicsImageView.image ?? UIImage(systemName: "doc.fill")!, text: cell.comicsTitleLabel.text ?? "")]
     
        initializeImageViewer(images: images)
    }
}

// MARK: - Scroll View Delegate
extension ComicsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let comicsViewModel = comicsViewModel else {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if isLoading || comicsViewModel.isAllComicsReceived {
                return
            }

            self.tableView.tableFooterView = self.createSpinner()

            loadData(offset: comicsViewModel.countOfComixes)
        }
    }
}

extension ComicsViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
}
