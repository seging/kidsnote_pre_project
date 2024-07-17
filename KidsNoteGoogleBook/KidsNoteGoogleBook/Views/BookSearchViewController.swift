//
//  HomeViewController.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/15/24.
//

import UIKit
import Combine
import KidsNoteGoogleBookTask

class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = CustomRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSearchController()
        bindViewModel()
        
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        tableView.register(SegmentedControlCell.self, forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(ResultLabelTableViewCell.self, forCellReuseIdentifier: "ResultLabelTableViewCell")
        tableView.register(NoResultsTableViewCell.self, forCellReuseIdentifier: "NoResultsTableViewCell")
        tableView.register(NetworkErrorTableViewCell.self, forCellReuseIdentifier: "NetworkErrorTableViewCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Play 북에서 검색"
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.tintColor = .label
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.updateUI(for: state)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(for state: State) {
        tableView.reloadData()
        if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.filterContent(by: sender.selectedSegmentIndex)
    }
    
    @objc private func retryButtonTapped() {
        if let query = searchController.searchBar.text, !query.isEmpty {
            viewModel.searchBooks(query: query)
        }
    }
    
    @objc private func refreshData() {
            if let query = searchController.searchBar.text, !query.isEmpty {
                viewModel.searchBooks(query: query)
            } else {
                refreshControl.endRefreshing()
            }
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.state {
        case .idle:
            return 0
        case .loading, .loaded, .error, .noResults:
            return 1
        @unknown default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .idle:
            return 0
        case .loading:
            return 2 // Loading Cell + Segment Control
        case .loaded(let books):
            return books.count + 3 // Segment Control + Result Label + Books + Loading Cell
        case .error:
            return 3 // Segment Control + Result Label + Error
        case .noResults:
            return 3 // Segment Control + Result Label + No Results
        @unknown default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .idle:
            return UITableViewCell()
        case .loading:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
                    return UITableViewCell()
                }
                cell.configure { [weak self] selectedIndex in
                    self?.viewModel.filterContent(by: selectedIndex)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                    return UITableViewCell()
                }
                return cell
            }
        case .loaded(let books):
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
                    return UITableViewCell()
                }
                cell.configure { [weak self] selectedIndex in
                    self?.viewModel.filterContent(by: selectedIndex)
                }
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultLabelTableViewCell", for: indexPath) as? ResultLabelTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            } else if indexPath.row - 2 < books.count  {//SegmentedControlCell,ResultLabelTableViewCell의 indexPath.row - 2
                let book = books[indexPath.row - 2] //SegmentedControlCell,ResultLabelTableViewCell의 indexPath.row - 2
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: book)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                    return UITableViewCell()
                }
                return cell
            }
        case .error:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
                    return UITableViewCell()
                }
                cell.configure { [weak self] selectedIndex in
                    self?.viewModel.filterContent(by: selectedIndex)
                }
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultLabelTableViewCell", for: indexPath) as? ResultLabelTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkErrorTableViewCell", for: indexPath) as? NetworkErrorTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure { [weak self] in
                    self?.retryButtonTapped()
                }
                return cell
            }
        case .noResults:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
                    return UITableViewCell()
                }
                cell.configure { [weak self] selectedIndex in
                    self?.viewModel.filterContent(by: selectedIndex)
                }
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultLabelTableViewCell", for: indexPath) as? ResultLabelTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsTableViewCell", for: indexPath) as? NoResultsTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            }
        @unknown default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsTableViewCell", for: indexPath) as? NoResultsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .loaded(books) = viewModel.state, indexPath.row > 1 {
            let book = books[indexPath.row - 2] //SegmentedControlCell,ResultLabelTableViewCell의 indexPath.row - 2
            let detailVC = BookDetailViewController()
            detailVC.viewModel = BookDetailViewModel(book: book)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchBooks(query: query)
    }
}


