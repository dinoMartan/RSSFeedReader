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
    
    func getOneRSSFeed(url: String, success: @escaping ((MyRSSFeed?) -> Void), failure: @escaping (() -> Void)) {
        alamofire.request(url).responseRSS { response in
            if let feed: RSSFeed = response.value {
                let myRSSFeed = MyRSSFeed(url: url, feed: feed)
                success(myRSSFeed)
            }
            else { failure() }
        }
    }
    
    /// Fetching [RSSFeed] for the given array of URLs
    func getMultipleRSSFeeds(feedUrls: [String], success: @escaping (([MyRSSFeed]) -> Void)) {
        var rssFeeds: [MyRSSFeed] = []
        let group = DispatchGroup()
        for url in feedUrls {
            group.enter()
            alamofire.request(url).responseRSS { response in
                if let feed: RSSFeed = response.value {
                    let myRSSFeed = MyRSSFeed(url: url, feed: feed)
                    rssFeeds.append(myRSSFeed)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            success(rssFeeds)
        }
    }

}
