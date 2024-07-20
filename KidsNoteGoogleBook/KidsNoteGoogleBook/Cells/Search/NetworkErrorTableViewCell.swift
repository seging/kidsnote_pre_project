//
//  NetworkErrorTableViewCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class NetworkErrorTableViewCell: UITableViewCell {
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 오류"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let errorMsgLabel: UILabel = {
        let label = UILabel()
        label.text = "인터넷 연결을 확인한 다음 다시 시도해 주세요."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.setTitle("다시 시도", for: .normal)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private var retryAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.addSubview(errorLabel)
        contentView.addSubview(errorMsgLabel)
        contentView.addSubview(retryButton)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
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
