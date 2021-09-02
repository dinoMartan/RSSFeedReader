//
//  RSSItemsViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import UIKit

class RSSItemsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Public properties
    
    static let identifier = "RSSItemsViewController"
    var feedImage: String?
    var items: [Item]?
    
    //MARK: - Private properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extension -

private extension RSSItemsViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        if items != nil {
            configureTableView()
        }
        else { dismiss(animated: true, completion: nil) }
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: RSSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RSSTableViewCell.identifier)
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension RSSItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items { return items.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell,
              let items = items else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configureCell(item: item, feedImage: feedImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
