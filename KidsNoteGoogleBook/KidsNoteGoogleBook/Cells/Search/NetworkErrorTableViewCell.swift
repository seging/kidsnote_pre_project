//
//  NetworkErrorTableViewCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class NetworkErrorTableViewCell: BaseTableViewCell {
    private var errorLabel: UILabel!
    private var errorMsgLabel: UILabel!
    private var retryButton: UIButton!
    
    private var retryAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        errorLabel = createLabel(text: "네트워크 오류", font: UIFont.boldSystemFont(ofSize: 25), textColor: .label, textAlignment: .center)
        errorMsgLabel = createLabel(text: "인터넷 연결을 확인한 다음 다시 시도해 주세요.", textColor: .secondaryLabel, textAlignment: .center)
        retryButton = createButton(title: "다시 시도", titleColor: .background, backgroundColor: .systemTeal, cornerRadius: 4)
        
        contentView.addSubview(errorLabel)
        contentView.addSubview(errorMsgLabel)
        contentView.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            errorMsgLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 15),
            errorMsgLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorMsgLabel.bottomAnchor, constant: 15),
            retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 35),
            retryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    @objc private func retryButtonTapped() {
        retryAction?()
    }
    
    func configure(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
}

