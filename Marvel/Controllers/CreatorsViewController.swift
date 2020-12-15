//
//  CreatorsViewController.swift
//  Marvel
//
//  Created by Olena Stepaniuk on 14.12.2020.
//

import UIKit

class CreatorsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var creatorsViewModel: CreatorsViewModel?
    var selectedRowNumber: Int?
    
    public var isLoading = false
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatorsViewModel = CreatorsViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: K.creatorCellNibName, bundle: nil), forCellReuseIdentifier: K.creatorCellIdentifier)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadData(
        offset: Int = 0,
        limit: Int = 20,
        nameStartsWith: String? = nil,
        needToCleanData: Bool? = nil
    ) {
        isLoading = true
        creatorsViewModel?.receiveData(offset, limit, nameStartsWith, needToCleanData, completion: { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            }
            self.isLoading = false
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.creatorsComixSegueIdentifier {
            let vc = segue.destination as? ComicsViewController
            guard let selectedRowNumber = selectedRowNumber, let safeVC = vc, let creatorsViewModel = creatorsViewModel else {
                return
            }
            if let comicsViewModel = creatorsViewModel.getComicsViewModelForCreator(with: selectedRowNumber) {
                safeVC.comicsViewModel = comicsViewModel
            }
            
        }
    }
}

// MARK: - Table View Data Source
extension CreatorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorsViewModel?.countOfCreators ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.creatorCellIdentifier, for: indexPath) as! CreatorTableViewCell
        guard let creatorsViewModel = creatorsViewModel else {
            return UITableViewCell()
        }
        
        cell.viewModel = creatorsViewModel.modelForCell(with: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        selectedRowNumber = indexPath.row
        performSegue(withIdentifier: K.creatorsComixSegueIdentifier, sender: self)
    }
}

// MARK: - Scroll View Delegate
extension CreatorsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let creatorsViewModel = creatorsViewModel else {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            guard !isLoading || creatorsViewModel.isAllCreatorsReceived else {
                return
            }
            
            self.tableView.tableFooterView = self.createSpinner()
            
            loadData(offset: creatorsViewModel.countOfCreators, nameStartsWith: searchBar.text == "" || searchBar.text == nil ? nil : searchBar.text)
        }
    }
}

// MARK: - Search Bar Delegate
extension CreatorsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadData(nameStartsWith: searchBar.text == "" || searchBar.text == nil ? nil : searchBar.text, needToCleanData: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData(nameStartsWith: searchBar.text == "" || searchBar.text == nil ? nil : searchBar.text, needToCleanData: true)
    }
}
