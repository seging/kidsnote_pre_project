//
//  BookTableViewCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit
import KidsNoteGoogleBookTask

class BookTableViewCell: UITableViewCell {
    
    let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    let eBookLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(bookImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(ratingLabel)
        addSubview(eBookLabel)
        
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        eBookLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bookImageView.widthAnchor.constraint(equalToConstant: 60),
            bookImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            ratingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            eBookLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            eBookLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8),
            eBookLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            eBookLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with book: BookItem) {
        titleLabel.text = book.volumeInfo.title
        authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        if let rating = book.volumeInfo.averageRating {
            ratingLabel.text = "Rating: \(rating)"
        }
        eBookLabel.text = "eBook"
        
        if let imageURL = book.volumeInfo.imageLinks?.thumbnail, let url = URL(string: imageURL) {
            // 이미지 로드 코드 추가
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.bookImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
