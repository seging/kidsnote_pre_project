//
//  No.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class NoResultsTableViewCell: UITableViewCell {
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
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
        contentView.addSubview(noResultsLabel)
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.selectionStyle = .none
        self.backgroundColor = .background
        NSLayoutConstraint.activate([
            noResultsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            noResultsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noResultsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noResultsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
