//
//  ComicsViewController.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 15.12.2020.
//

import UIKit

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
            guard !isLoading || comicsViewModel.isAllComicsReceived else {
                return
            }
            
            self.tableView.tableFooterView = self.createSpinner()
            
            loadData(offset: comicsViewModel.countOfComixes)
        }
    }
}
