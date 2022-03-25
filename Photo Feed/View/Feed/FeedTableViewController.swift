//
//  FeedViewController.swift
//  Photo Feed
//
//  Created by Artem Yakovlev on 24.03.2022.
//

import UIKit

class FeedTableViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageView: FeedMessageView!
    
    private let dataSource = FeedDelegateDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView.backgroundView = messageView
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func loadData() {
        dataSource.loadPhotos { [weak self] status in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.messageView.isHidden = status == .loaded
                
                switch status {
                case .empty:
                    self.messageView.setText("Photo library is empty or you didn't share any photos")
                    
                case .accessDenied:
                    self.messageView.setText("Access to the photo library is denied.\nPlease go to the settings and allow access to the library")
                
                case .loaded:
                    break
                }
            }
        }
    }

}

