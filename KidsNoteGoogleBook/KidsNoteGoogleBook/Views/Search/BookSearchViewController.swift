//
//  HomeViewController.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/15/24.
//

import UIKit
import Combine
import KidsNoteGoogleBookTask

class BookSearchViewController: BaseViewController {
    private let viewModel = BookSearchViewModel()
    private let customSearchView = CustomSearchView(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width - 40, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        
        setupSearchController()
        bindViewModel()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(hiddenUnderline: false, backgroundColor: .navigation, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBarStyle(hiddenUnderline: true, backgroundColor: .navigation, animated: animated)
    }
    
    override func setupTableView() {
        super.setupTableView()
        self.registerCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupUI() {
        self.view.backgroundColor = .navigation
    }
    
    private func setupSearchController() {
        customSearchView.delegate = self
        addNavigationBarUnderline()
        self.navigationItem.titleView = customSearchView
    }
    
    private func registerCells() {
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        tableView.register(SegmentedControlCell.self, forCellReuseIdentifier: "SegmentedControlCell")
        tableView.register(ResultLabelTableViewCell.self, forCellReuseIdentifier: "ResultLabelTableViewCell")
        tableView.register(NoResultsTableViewCell.self, forCellReuseIdentifier: "NoResultsTableViewCell")
        tableView.register(NetworkErrorTableViewCell.self, forCellReuseIdentifier: "NetworkErrorTableViewCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
    }
    
    override func refreshData() {
        if let query = customSearchView.searchBar.text, !query.isEmpty {
            viewModel.searchBooks(query: query)
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(for: state)
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
        if let query = customSearchView.searchBar.text, !query.isEmpty {
            viewModel.searchBooks(query: query)
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
            return getLoadingCell(for: indexPath)
        case .loaded(let books):
            return getLoadedCell(for: indexPath, books: books)
        case .error:
            return getErrorCell(for: indexPath)
        case .noResults(let msg):
            return getNoResultsCell(for: indexPath, message: msg)
        @unknown default:
            return UITableViewCell()
        }
    }
    
    private func getLoadingCell(for indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return dequeueSegmentedControlCell(for: indexPath)
        } else {
            return dequeueLoadingCell(for: indexPath)
        }
    }
    
    private func getLoadedCell(for indexPath: IndexPath, books: [BookItem]) -> UITableViewCell {
        if indexPath.row == 0 {
            return dequeueSegmentedControlCell(for: indexPath)
        } else if indexPath.row == 1 {
            return dequeueResultLabelCell(for: indexPath)
        } else if indexPath.row - 2 < books.count {
            let book = books[indexPath.row - 2]
            return dequeueBookCell(for: indexPath, with: book)
        } else {
            return dequeueLoadingCell(for: indexPath)
        }
    }
    
    private func getErrorCell(for indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return dequeueSegmentedControlCell(for: indexPath)
        } else if indexPath.row == 1 {
            return dequeueResultLabelCell(for: indexPath)
        } else {
            return dequeueNetworkErrorCell(for: indexPath)
        }
    }
    
    private func getNoResultsCell(for indexPath: IndexPath, message: String) -> UITableViewCell {
        if indexPath.row == 0 {
            return dequeueSegmentedControlCell(for: indexPath)
        } else if indexPath.row == 1 {
            return dequeueResultLabelCell(for: indexPath)
        } else {
            return dequeueNoResultsCell(for: indexPath, message: message)
        }
    }
    
    private func dequeueSegmentedControlCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedControlCell", for: indexPath) as? SegmentedControlCell else {
            return UITableViewCell()
        }
        cell.configure { [weak self] selectedIndex in
            self?.viewModel.filterContent(by: selectedIndex)
        }
        return cell
    }
    
    private func dequeueLoadingCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    private func dequeueResultLabelCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultLabelTableViewCell", for: indexPath) as? ResultLabelTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    private func dequeueBookCell(for indexPath: IndexPath, with book: BookItem) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: book)
        return cell
    }
    
    private func dequeueNetworkErrorCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkErrorTableViewCell", for: indexPath) as? NetworkErrorTableViewCell else {
            return UITableViewCell()
        }
        cell.configure { [weak self] in
            self?.retryButtonTapped()
        }
        return cell
    }
    
    private func dequeueNoResultsCell(for indexPath: IndexPath, message: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsTableViewCell", for: indexPath) as? NoResultsTableViewCell else {
            return UITableViewCell()
        }
        cell.updateResult(msg: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .loaded(books) = viewModel.state, indexPath.row > 1 {
            let book = books[indexPath.row - 2]
            let detailVC = BookDetailViewController()
            detailVC.viewModel = BookDetailViewModel(book: book)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension BookSearchViewController: CustomSearchViewDelegate {
    func customSearchViewDidSearch(_ searchView: CustomSearchView, query: String) {
        viewModel.searchBooks(query: query)
    }
    
    func customSearchView(_ searchView: CustomSearchView, textDidChange searchText: String?) {
        guard let query = searchText, !query.isEmpty else {
            viewModel.resetStateIfNeeded()
            return
        }
    }
    
    func customSearchViewDidClear(_ searchView: CustomSearchView) {
        viewModel.resetStateIfNeeded()
    }
}

