//
//  BookInfoCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit
import KidsNoteGoogleBookTask

class BookInfoCell: UITableViewCell {
    private let bookImageView:UIImageView = UIImageView()
    private let titleLabel:UILabel =  {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 21)
        return label
    }()
    private let authorLabel:UILabel =  {
        let label = UILabel()
         
         label.textColor = .naviTint
         label.font = .systemFont(ofSize: 14)
         return label
     }()
    private let pageCountLabel:UILabel =  {
        let label = UILabel()
         
         label.textColor = .naviTint
         label.font = .systemFont(ofSize: 14)
         return label
     }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSeparatorInsets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSeparatorInsets() {
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
    }

    private func setupUI() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(pageCountLabel)
        self.selectionStyle = .none
        self.backgroundColor = .background
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        pageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookImageView.widthAnchor.constraint(equalToConstant: 100),
            bookImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor,constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            pageCountLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor,constant: 5),
            pageCountLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            pageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
        ])

    }

    func configure(with book: BookItem) {
        if let imageUrl = book.volumeInfo.imageLinks?.thumbnail {
            bookImageView.loadImage(from: URL(string: imageUrl)!)
        }
        titleLabel.text = book.volumeInfo.title
        authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        pageCountLabel.text = "eBook ∙ \(book.volumeInfo.pageCount ?? 0)페이지"
    }
}

