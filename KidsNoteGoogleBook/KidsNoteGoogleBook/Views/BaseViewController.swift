//
//  BaseViewController.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/21/24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    let tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func refreshData() {
        // Override in subclass
    }
    
    func setNavigationBarStyle(hiddenUnderline: Bool, backgroundColor: UIColor, animated: Bool) {
            let duration = animated ? 0.25 : 0.0
            UIView.animate(withDuration: duration) {
                self.tableView.backgroundColor = .background
                self.navigationController?.navigationBar.backgroundColor = backgroundColor
                self.navigationController?.navigationBar.viewWithTag(1001)?.isHidden = hiddenUnderline
            }
        }
        
        func addNavigationBarUnderline() {
            let underline = UIView()
            underline.backgroundColor = .naviLine
            underline.translatesAutoresizingMaskIntoConstraints = false
            underline.tag = 1001
            
            navigationController?.navigationBar.addSubview(underline)
            
            NSLayoutConstraint.activate([
                underline.heightAnchor.constraint(equalToConstant: 1),
                underline.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
                underline.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
                underline.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor)
            ])
        }
    
}
