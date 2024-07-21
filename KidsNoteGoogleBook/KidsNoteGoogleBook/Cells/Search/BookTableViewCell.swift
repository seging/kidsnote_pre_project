//
//  BookTableViewCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit
import KidsNoteGoogleBookTask

class BookTableViewCell: BaseTableViewCell {
    
    private var bookImageView: UIImageView!
    private var titleLabel: UILabel!
    private var authorLabel: UILabel!
    private var ratingLabel: UILabel!
    private var eBookLabel: UILabel!
    private var ratingImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            contentView.alpha = 0.5
        } else {
            contentView.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.cancelImageLoad() // 이미지 로드 작업 취소
        bookImageView.image = nil // 셀을 재사용할 때 이미지 초기화
        
        titleLabel.text = nil
        authorLabel.text = nil
        ratingLabel.text = nil
        ratingImageView.isHidden = true
        eBookLabel.text = nil
    }
    
    private func setupUI() {
        bookImageView = createImageView(contentMode: .scaleAspectFill, cornerRadius: 4)
        titleLabel = createLabel(font: .boldSystemFont(ofSize: 16), numberOfLines: 2)
        authorLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)
        ratingLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .systemGray)
        eBookLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .systemGray)
        ratingImageView = createImageView(image: UIImage(systemName: "star.fill"), tintColor: .systemGray)
        
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(eBookLabel)
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bookImageView.widthAnchor.constraint(equalToConstant: 90),
            bookImageView.heightAnchor.constraint(equalToConstant: 130),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            eBookLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            eBookLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 10),
            
            ratingLabel.topAnchor.constraint(equalTo: eBookLabel.topAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: eBookLabel.trailingAnchor, constant: 5),
            
            ratingImageView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 5),
            ratingImageView.centerYAnchor.constraint(equalTo: eBookLabel.centerYAnchor),
            ratingImageView.widthAnchor.constraint(equalToConstant: 14),
            ratingImageView.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    func configure(with book: BookItem) {
        titleLabel.text = book.volumeInfo.title
        authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        if let rating = book.volumeInfo.averageRating {
            ratingLabel.text = "\(rating)"
            ratingImageView.isHidden = rating == .zero
        } else {
            ratingImageView.isHidden = true
        }
        eBookLabel.text = "eBook"
        
        guard let imageURLString = book.volumeInfo.imageLinks?.thumbnail, let url = URL(string: imageURLString) else {
            bookImageView.image = nil
            return
        }
        
        bookImageView.loadImage(from: url)
    }
}


