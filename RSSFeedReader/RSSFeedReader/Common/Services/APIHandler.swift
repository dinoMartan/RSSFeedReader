//
//  APIHandler.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import Foundation
import Alamofire
import AlamofireRSSParser

class APIHandler {

    //MARK: - Public properties
    
    static let shared = APIHandler()

    //MARK: - Private properties

    private let alamofire = AF
    
    //MARK: - Public methods
    
    /// Fetching [RSSFeed] for the given array of URLs
    func getRSSFeeds(feedUrls: [String], success: @escaping (([RSSFeed]) -> Void)) {
        var rssFeeds: [RSSFeed] = []
        let group = DispatchGroup()
        for url in feedUrls {
            group.enter()
            alamofire.request(url).responseRSS { response in
                if let feed: RSSFeed = response.value {
                    rssFeeds.append(feed)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            success(rssFeeds)
        }
    }

}