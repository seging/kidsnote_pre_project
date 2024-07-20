//
//  BookDetailViewController.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/15/24.
//

import UIKit
import Combine
import KidsNoteGoogleBookTask
import SafariServices

class BookDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel: BookDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(hiddenUnderline: true, backgroundColor: .background, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBarStyle(hiddenUnderline: false, backgroundColor: .navigation, animated: true)
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("뒤로", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 이미지와 타이틀 간의 간격 설정
        backButton.semanticContentAttribute = .forceLeftToRight
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        let shareText = viewModel.title
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        self.view.backgroundColor = .background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(BookInfoCell.self, forCellReuseIdentifier: "BookInfoCell")
        tableView.register(ButtonsCell.self, forCellReuseIdentifier: "ButtonsCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
        tableView.register(RatingCell.self, forCellReuseIdentifier: "RatingCell")
        tableView.register(PublishDateCell.self, forCellReuseIdentifier: "PublishDateCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$rating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rating in
                self?.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
            .store(in: &cancellables)
        
        viewModel.$ratingCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ratingCount in
                self?.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
            .store(in: &cancellables)
        
        viewModel.$isInWishlist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isInWishlist in
                self?.updateWishlistButton()
            }
            .store(in: &cancellables)
    }
    
    private func updateWishlistButton() {
        guard let buttonsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ButtonsCell else { return }
        
        buttonsCell.updateWishlistButton(isInWishlist: viewModel.isInWishlist)
    }
    
    private func openPreview() {
            guard let previewLink = viewModel.previewLink, let url = URL(string: previewLink) else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.hasRating ? 5 : 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !viewModel.hasRating && indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublishDateCell", for: indexPath) as! PublishDateCell
            cell.configure(book: viewModel.book)
            return cell
        }

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookInfoCell", for: indexPath) as! BookInfoCell
            cell.configure(with: viewModel.book)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
            cell.configure(sampleReadAction: { [weak self] in
                self?.openPreview()
            }, wishlistAction: { [weak self] in
                self?.viewModel.toggleWishlistStatus()
            })
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.configure(description: viewModel.description)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
            cell.configure(rating: viewModel.rating, ratingCount: viewModel.ratingCount)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublishDateCell", for: indexPath) as! PublishDateCell
            cell.configure(book: viewModel.book)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.hasRating && indexPath.section == 3 {
            return 80 // Publish Date Cell height when RatingCell is absent
        }

        switch indexPath.section {
        case 0:
            return 180 // Book Info Cell height
        case 1:
            return 120 // Buttons Cell height
        case 2:
            return 150 // Description Cell height
        case 3:
            return 140 // Rating Cell height
        case 4:
            return 80 // Publish Date Cell height
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    private func setNavigationBarStyle(hiddenUnderline: Bool, backgroundColor: UIColor, animated: Bool) {
        let duration = animated ? 0.25 : 0.0
        
        UIView.animate(withDuration: duration) {
            self.tableView.backgroundColor = .background
            self.navigationController?.navigationBar.backgroundColor = backgroundColor
            self.navigationController?.navigationBar.viewWithTag(1001)?.isHidden = hiddenUnderline
        }
    }
}

