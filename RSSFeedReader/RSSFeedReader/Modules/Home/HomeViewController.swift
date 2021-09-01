//
//  HomeViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    //MARK: - Public properties
    
    static let identifier = "HomeViewController"
    
    //MARK: - Private properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func didTapTestButton(_ sender: Any) {
        fetchRSSFeeds()
    }
    
}

//MARK: - Private extension -

private extension HomeViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        fetchRSSFeeds()
    }
    
    //MARK: - Data
    
    private func fetchRSSFeeds() {
        let urls = ["https://feeds.megaphone.fm/ADL9840290619", "https://feeds.megaphone.fm/WWO3519750118"]
        APIHandler.shared.getRSSFeeds(feedUrls: urls) { rssFeeds in
            print(rssFeeds.count)
        }
    }
    
}
