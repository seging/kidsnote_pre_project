//
//  Descrip.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit

class DescriptionCell: BaseTableViewCell {
    private var headerLabel: UILabel!
    private var arrowImageView: UIImageView!
    private var descriptionLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        headerLabel = createLabel(text: "eBook 정보", font: .boldSystemFont(ofSize: 16), textColor: .label)
        arrowImageView = createImageView(image: UIImage(systemName: "chevron.right"), tintColor: .selectedTab)
        descriptionLabel = createLabel(textColor: .naviTint, numberOfLines: 0)

        contentView.addSubview(headerLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 8),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(description: String) {
        descriptionLabel.text = description
    }
}

