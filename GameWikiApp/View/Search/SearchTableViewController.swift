//
//  SearchTableViewController.swift
//  GameApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import Foundation
import UIKit
import Combine
import MBProgressHUD
import SCLAlertView

class SearchTableViewController: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case beginning
        case search
    }
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = LocalizableString.EnterGame.localized
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    private var asset: Asset?
    @Published private var mode: Mode = .beginning
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        observeForm()
    }
    
    private func observeForm() {
        $searchQuery.handleEvents(receiveOutput: { [unowned self] output in
            guard !output.isEmpty else { return }
            showLoadingAnimation()
        }).debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                
                self.apiService.fetchGameNamePublisher(keywords: searchQuery).sink { [unowned self] completion in
                    self.hideLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { searchResults in
                    if searchQuery != "" {
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                    self.tableView.isScrollEnabled = true
                    print(searchResults)
                    }
                }.store(in: &subscribers)
            }.store(in: &subscribers)
        $mode.sink { [unowned self] mode in
            switch mode {
            case .beginning:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    private func rowSelected(for id: Int, searchResult: SearchData) {
        showLoadingAnimation()
        apiService.fetchGameDetailPublisher(id: id).sink { [weak self] completionResult in
            self?.hideLoadingAnimation()
            switch completionResult {
            case .failure(let error):
                print(error)
                SCLAlertView().showError(LocalizableString.Error.localized, subTitle: LocalizableString.DataNotFound.localized)
            case .finished: break
            }
        } receiveValue: { [weak self] gameDetail in
            self?.hideLoadingAnimation()
            let asset = Asset(searchResult: searchResult, gameDetails: gameDetail)
            self?.performSegue(withIdentifier: "showDetail", sender: asset)
            self?.searchController.searchBar.text = nil
            //print("success \(gameDetail)")
        }.store(in: &subscribers)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        title = LocalizableString.SearchScreenTitle.localized
    }
    
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell
        if let searchResults = searchResults {
            let searchResult = searchResults.results[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let searchResults = self.searchResults {
            let searchResult = searchResults.results[indexPath.row]
            let id = searchResult.id
            rowSelected(for: id, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destination = segue.destination as? DetailViewController,
           let asset = sender as? Asset {
            destination.asset = asset
        }
    }
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              !searchQuery.isEmpty else {return}
        self.searchQuery = searchQuery
        
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
            mode = .search
    }
}

