//
//  ButtonsCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit

class ButtonsCell: UITableViewCell {
    private let sampleReadButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.naviLine.cgColor
        button.setTitle("샘플 읽기", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.selectedTab, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    private let wishlistButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("위시리스트에서 추가", for: .normal)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .background
        button.backgroundColor = .selectedTab
        button.setTitleColor(.background, for: .normal)
        button.titleLabel!.font = .boldSystemFont(ofSize: 12)
        return button
    }()
    private let infoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.contentMode = .center
        imageView.tintColor = .naviLine
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true // 이미지 크기 조절
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true // 이미지 크기 조절
        return imageView
    }()
    private let infoLabel:UILabel = {
        let label = UILabel()
        label.text = "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다."
        label.numberOfLines = 2
        label.textColor = .naviLine
        label.font = UIFont.systemFont(ofSize: 14) // 폰트 크기 조절
        return label
    }()
    
    private var sampleReadAction: (() -> Void)?
    private var wishlistAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSeparatorInsets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSeparatorInsets() {
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    private func setupUI() {
        contentView.addSubview(sampleReadButton)
        contentView.addSubview(wishlistButton)
        contentView.addSubview(infoImageView)
        contentView.addSubview(infoLabel)
        self.backgroundColor = .background
        self.selectionStyle = .none
        sampleReadButton.translatesAutoresizingMaskIntoConstraints = false
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sampleReadButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            sampleReadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sampleReadButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            sampleReadButton.heightAnchor.constraint(equalToConstant: 40),
            
            wishlistButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            wishlistButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            wishlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wishlistButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoLabel.topAnchor.constraint(equalTo: sampleReadButton.bottomAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: wishlistButton.trailingAnchor, constant: -20),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 10),
            
            
            infoImageView.leadingAnchor.constraint(equalTo: sampleReadButton.leadingAnchor),
            infoImageView.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            infoImageView.widthAnchor.constraint(equalToConstant: 18), // 이미지 크기 조절
            infoImageView.heightAnchor.constraint(equalToConstant: 18), // 이미지 크기 조절
        ])
    }
    
    func configure(sampleReadAction: @escaping () -> Void, wishlistAction: @escaping () -> Void) {
        self.sampleReadAction = sampleReadAction
        self.wishlistAction = wishlistAction
        
        sampleReadButton.addTarget(self, action: #selector(sampleReadButtonTapped), for: .touchUpInside)
        wishlistButton.addTarget(self, action: #selector(wishlistButtonTapped), for: .touchUpInside)
    }
    
    func updateWishlistButton(isInWishlist: Bool) {
        if isInWishlist {
                   wishlistButton.setTitle("위시리스트에서 제거", for: .normal)
                   wishlistButton.setImage(UIImage(systemName: "bookmark.slash"), for: .normal)
               } else {
                   wishlistButton.setTitle("위시리스트에 추가", for: .normal)
                   wishlistButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
               }
               wishlistButton.imageView?.contentMode = .scaleAspectFit
               wishlistButton.contentHorizontalAlignment = .center
    }
    
    @objc private func sampleReadButtonTapped() {
        sampleReadAction?()
    }
    
    @objc private func wishlistButtonTapped() {
        wishlistAction?()
    }
}

