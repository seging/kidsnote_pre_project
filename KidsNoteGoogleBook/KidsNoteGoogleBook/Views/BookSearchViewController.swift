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
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["eBook", "오디오북"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Google Play 검색결과"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 오류"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private let errorMsgLabel: UILabel = {
        let label = UILabel()
        label.text = "인터넷 연결을 확인한 다음 다시 시도해 주세요."
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.setTitle("다시 시도", for: .normal)
        button.backgroundColor = .systemTeal
        
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSearchController()
        bindViewModel()
        
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        
    }
    
    private func setupUI() {
        view.addSubview(segmentedControl)
        view.addSubview(resultLabel)
        view.addSubview(noResultsLabel)
        view.addSubview(errorLabel)
        view.addSubview(errorMsgLabel)
        view.addSubview(retryButton)
        view.addSubview(tableView)
        
        view.backgroundColor = .systemBackground
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            resultLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            noResultsLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 8),
            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            errorLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            errorMsgLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 15),
            errorMsgLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorMsgLabel.bottomAnchor, constant: 15),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 35),
            
            tableView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        switch state {
        case .idle:
            segmentedControl.isHidden = true
            noResultsLabel.isHidden = true
            errorLabel.isHidden = true
            retryButton.isHidden = true
            resultLabel.isHidden = true
        case .loading:
            noResultsLabel.isHidden = true
            errorLabel.isHidden = true
            errorMsgLabel.isHidden = true
            retryButton.isHidden = true
        case .loaded(let books):
            segmentedControl.isHidden = false
            resultLabel.isHidden = false
            noResultsLabel.isHidden = !books.isEmpty
            tableView.reloadData()
            tableView.isHidden = books.isEmpty
        case .error( _):
            segmentedControl.isHidden = false
            resultLabel.isHidden = false
            noResultsLabel.isHidden = true
            errorLabel.isHidden = false
            errorMsgLabel.isHidden = false
            retryButton.isHidden = false
            tableView.isHidden = true
        case .noResults(let message):
            noResultsLabel.text = message
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        @unknown default:
            break
        }
    }
    
    @objc private func retryButtonTapped() {
        if let query = searchController.searchBar.text, !query.isEmpty {
            viewModel.searchBooks(query: query)
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.filterContent(by: sender.selectedSegmentIndex)
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .loaded(books) = viewModel.state {
            return books.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        if case let .loaded(books) = viewModel.state {
            let book = books[indexPath.row]
            cell.configure(with: book) 
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .loaded(books) = viewModel.state {
            let book = books[indexPath.row]
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

