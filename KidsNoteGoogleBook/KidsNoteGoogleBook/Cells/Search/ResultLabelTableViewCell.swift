//
//  ResultLabelCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class ResultLabelTableViewCell: BaseTableViewCell {
    private var resultLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        resultLabel = createLabel(text: "Google Play 검색결과", font: .italicSystemFont(ofSize: 20), textAlignment: .left)
        
        contentView.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

