//
//  HomeViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import SkeletonView

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addNewFeedButton: UIButton!
    
    //MARK: - Public properties
    
    static let identifier = "HomeViewController"
    
    //MARK: - Private properties
    
    private var feeds: [MyRSSFeed] = []
    
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
        configureTableView()
        fetchMyRssFeeds()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: RSSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RSSTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchMyRssFeeds() {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .rssGradient1, secondaryColor: .rssGrafient2), animation: .none, transition: .crossDissolve(1))
        let myFeeds = CurrentUser.shared.getMyFeeds()
        APIHandler.shared.getMultipleRSSFeeds(feedUrls: myFeeds) { [unowned self] rssFeeds in
            feeds = rssFeeds
            tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension HomeViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell else {
            return UITableViewCell()
        }
        let myRSSFeed = feeds[indexPath.row]
        cell.configureCell(feed: myRSSFeed.feed)
        return cell
    }
    
    //MARK: - TableView Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rssItemsStoryboard = UIStoryboard(name: "RSSItems", bundle: nil)
        guard let rssItemsViewController = rssItemsStoryboard.instantiateViewController(identifier: RSSItemsViewController.identifier) as? RSSItemsViewController else { return }
        let currentFeed = feeds[indexPath.row]
        let rssItems = currentFeed.feed.channel.items
        rssItemsViewController.items = rssItems
        rssItemsViewController.feedImage = currentFeed.feed.channel.image?.url
        navigationController?.pushViewController(rssItemsViewController, animated: true)
    }
    
    //MARK: - SkeletonView
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RSSTableViewCell.identifier
    }
    
    //MARK: - Row/feed deletion
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: AlertsContants.deleteFeedQuestion.rawValue, message: AlertsContants.actionCannotBeUndone.rawValue, preferredStyle: .actionSheet)
            let alertActionOk = UIAlertAction(title: AlertsContants.ok.rawValue, style: .destructive) { [unowned self] _ in
                removeFeed(at: indexPath)
            }
            let alertActionCancel = UIAlertAction(title: AlertsContants.cancel.rawValue, style: .cancel, handler: nil)
            alertController.addAction(alertActionOk)
            alertController.addAction(alertActionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper methods
    
    func removeFeed(at indexPath: IndexPath) {
        let feedIndex = indexPath.row
        let myRSSFeed = feeds[feedIndex]
        let feedUrl = myRSSFeed.url
        if CurrentUser.shared.removeMyFeed(url: feedUrl) {
            feeds.remove(at: feedIndex)
            tableView.reloadData()
        }
        else {
            // to do - handle error
        }
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
        } failure: { error in
            // to do - handle error
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
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        let searchStoryboard = UIStoryboard(name: "RSSSearch", bundle: nil)
        guard let searchViewController = searchStoryboard.instantiateViewController(identifier: RSSSearchViewController.identifier) as? RSSSearchViewController else { return }
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
}
