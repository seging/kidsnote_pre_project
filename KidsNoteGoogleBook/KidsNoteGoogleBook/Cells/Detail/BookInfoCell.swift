//
//  BookInfoCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit
import KidsNoteGoogleBookTask

class BookInfoCell: BaseTableViewCell {
    private var bookImageView:UIImageView!
    private var titleLabel:UILabel!
    private var authorLabel:UILabel!
    private var pageCountLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        bookImageView = createImageView(cornerRadius: 4)
        titleLabel = createLabel(font: .boldSystemFont(ofSize: 21), numberOfLines: 2)
        authorLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .naviTint)
        pageCountLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .naviTint)
        
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(pageCountLabel)
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookImageView.widthAnchor.constraint(equalToConstant: 100),
            bookImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            pageCountLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
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


