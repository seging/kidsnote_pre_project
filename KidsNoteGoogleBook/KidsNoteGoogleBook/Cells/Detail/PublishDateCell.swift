//
//  File.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit
import KidsNoteGoogleBookTask

class PublishDateCell: UITableViewCell {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "게시일"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16) // 폰트 크기와 스타일 조정
        
        return label
    }()
    private let publishDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .naviTint
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14) // 폰트 크기와 스타일 조정
        
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
        contentView.addSubview(headerLabel)
        contentView.addSubview(publishDateLabel)
        
        self.backgroundColor = .background
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            publishDateLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            publishDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publishDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            publishDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        publishDateLabel.numberOfLines = 0
    }

    func configure(book: BookItem) {
        guard let publishedDate = book.volumeInfo.publishedDate, let publisher = book.volumeInfo.publisher else { return }
        
        publishDateLabel.text = "\(publishedDate)∙\(publisher)"
    }
}
