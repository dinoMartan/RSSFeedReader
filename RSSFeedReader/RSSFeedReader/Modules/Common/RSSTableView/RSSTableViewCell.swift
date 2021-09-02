//
//  HomeTableViewCell.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import AlamofireRSSParser
import SDWebImage

class RSSTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var feedNameLabel: UILabel!
    @IBOutlet private weak var feedDescriptionLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "RSSTableViewCell"
    
    //MARK: - Public methods
    
    func configureCell(feed: RSSFeed) {
        if let image = feed.items.first?.imagesFromContent?.first ?? feed.items.first?.imagesFromDescription?.first {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        feedNameLabel.text = feed.title ?? "N/A"
        feedDescriptionLabel.text = feed.feedDescription ?? "N/A"
    }
    
    func configureCell(item: RSSItem) {
        if let image = item.imagesFromContent?.first ??
            item.imagesFromDescription?.first {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        feedNameLabel.text = item.title ?? "N/A"
        feedDescriptionLabel.text = item.itemDescription ?? "N/A"
    }
    
}
