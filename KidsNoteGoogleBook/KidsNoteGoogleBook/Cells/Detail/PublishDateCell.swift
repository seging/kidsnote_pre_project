//
//  File.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit
import KidsNoteGoogleBookTask

class PublishDateCell: BaseTableViewCell {
    private var headerLabel: UILabel!
    private var publishDateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        headerLabel = createLabel(text: "게시일", font: .boldSystemFont(ofSize: 16), textColor: .label)
        publishDateLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .naviTint, numberOfLines: 0)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(publishDateLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            publishDateLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            publishDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publishDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            publishDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(book: BookItem) {
        guard let publishedDate = book.volumeInfo.publishedDate, let publisher = book.volumeInfo.publisher else { return }
        
        publishDateLabel.text = "\(publishedDate)∙\(publisher)"
    }
}

