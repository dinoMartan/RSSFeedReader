//
//  RSSSearchViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 03/09/2021.
//

import UIKit
import SkeletonView
import SafariServices

class RSSSearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Public properties
    
    static let identifier = "RSSSearchViewController"
    
    //MARK: - Private properties
    
    private var searchResult: SearchResult?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extension -

private extension RSSSearchViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        configureTableView()
        configureSearchBar()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: RSSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RSSTableViewCell.identifier)
    }
    
    //MARK: - SearchBar Configuration
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    //MARK: - Data
    
    private func fetchData(query: String) {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .rssGradient1, secondaryColor: .rssGrafient2), animation: .none, transition: .crossDissolve(1))
        APIHandler.shared.searchFeeds(query: query) { [unowned self] searchRes in
            searchResult = searchRes
            tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1.0))
        } failure: { error in
            // to do - handle error
            print(error.localizedDescription)
        }

    }
    
}

//MARK: - TableView DataSource and Delegate -

extension RSSSearchViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    //MARK: - NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = searchResult?.results else { return 0 }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell,
              let results = searchResult?.results
        else { return UITableViewCell() }
        let result = results[indexPath.row]
        cell.configureCell(result: result)
        return cell
    }
    
    //MARK: - SkeletonView
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RSSTableViewCell.identifier
    }
    
    //MARK: - Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let results = searchResult?.results,
              let website = results[indexPath.row].website,
              let url = URL(string: website)
              else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - Swipe actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: AlertsContants.addFeed.rawValue) { [unowned self] (_, _, completionHandler) in
            completionHandler(true)
            addNewFeed()
        }
        action.backgroundColor = .rssGradient1
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - Helper methods
    
    private func addNewFeed() {
        print("add Feed")
    }
    
}

//MARK: - SearchBar Delegate -

extension RSSSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text,
           text != "" {
            fetchData(query: text)
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
