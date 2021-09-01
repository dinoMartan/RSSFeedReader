//
//  CurrentUser.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import Foundation

class CurrentUser {
    
    //MARK: - Public properties
    
    static let shared = CurrentUser()
    
    //MARK: - Private properties
    
    private let defaults = UserDefaults.standard
    
    private var myFeeds: [String] {
        let feeds = defaults.object(forKey: UserDefaultsConstants.myFeeds.rawValue) as? [String] ?? [String]()
        return feeds
    }
    
    //MARK: - public methods
    
    func getMyFeeds() -> [String] {
        return myFeeds
    }
    
    func addNewFeed(url: String) {
        var myFeeds = getMyFeeds()
        myFeeds.append(url)
        defaults.setValue(myFeeds, forKey: UserDefaultsConstants.myFeeds.rawValue)
    }
    
}
