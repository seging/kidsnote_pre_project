//
//  BookDetailViewController.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/15/24.
//

import UIKit
import KidsNoteGoogleBookTask

class BookDetailViewController: UIViewController {
    var viewModel: BookDetailViewModel?

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabels()
        displayBookDetails()
    }

    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        authorLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func displayBookDetails() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.book.volumeInfo.title
        authorLabel.text = viewModel.book.volumeInfo.authors?.joined(separator: ", ")
        descriptionLabel.text = viewModel.book.volumeInfo.description
    }
}
