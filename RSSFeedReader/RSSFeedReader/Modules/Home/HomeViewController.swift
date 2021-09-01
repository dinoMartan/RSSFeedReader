//
//  HomeViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import AlamofireRSSParser

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addNewFeedButton: UIButton!
    
    //MARK: - Public properties
    
    static let identifier = "HomeViewController"
    
    //MARK: - Private properties
    
    private var feeds: [RSSFeed] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
}

//MARK: - Private extension -

private extension HomeViewController {
    
    //MARK: - UI Configuration
    
    private func configureUI() {
        addNewFeedButton.layer.cornerRadius = addNewFeedButton.frame.height / 2
    }
    
    //MARK: - View Setup
    
    private func setupView() {
        fetchMyRssFeeds()
        configureTableView()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Data
    
    private func fetchMyRssFeeds() {
        let myFeeds = CurrentUser.shared.getMyFeeds()
        APIHandler.shared.getMultipleRSSFeeds(feedUrls: myFeeds) { [unowned self] rssFeeds in
            feeds = rssFeeds
            tableView.reloadData()
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - NewFeedDelegate -

extension HomeViewController: NewFeedViewControllerDelegate {
    
    func didAddNewFeed(feedUrl: String) {
        CurrentUser.shared.addNewFeed(url: feedUrl)
        APIHandler.shared.getOneRSSFeed(url: feedUrl) { [unowned self] rssFeed in
            guard let feed = rssFeed else { return }
            feeds.append(feed)
            tableView.reloadData()
        } failure: {
            //
        }

    }
    
}

//MARK: - IBActions -

extension HomeViewController {
    
    @IBAction func didTapAddNewFeedButton(_ sender: Any) {
        let newFeedStoryboard = UIStoryboard.init(name: "NewFeed", bundle: nil)
        guard let newFeedViewController = newFeedStoryboard.instantiateViewController(identifier: NewFeedViewController.identifier) as? NewFeedViewController else { return }
        newFeedViewController.delegate = self
        present(newFeedViewController, animated: true, completion: nil)
    }
    
}
