//
//  ButtonsCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit

class ButtonsCell: BaseTableViewCell {
    private var sampleReadButton: UIButton!
    private var wishlistButton: UIButton!
    private var infoImageView: UIImageView!
    private var infoLabel: UILabel!
    
    private var sampleReadAction: (() -> Void)?
    private var wishlistAction: (() -> Void)?
    
    private let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator // UITableView의 구분선과 동일한 색상 사용
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        sampleReadButton = createButton(title: "샘플 읽기", titleColor: .selectedTab, borderWidth: 0.5, borderColor: .naviLine)
        wishlistButton = createButton(title: "위시리스트에서 추가", titleColor: .navigation, backgroundColor: .selectedTab,tintColor: .navigation)
        infoImageView = createImageView(image: UIImage(systemName: "info.circle"), tintColor: .naviTint)
        infoLabel = createLabel(text: "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다.", font: .systemFont(ofSize: 12), textColor: .naviTint, numberOfLines: 2)
        
        contentView.addSubview(topSeparator)
        contentView.addSubview(sampleReadButton)
        contentView.addSubview(wishlistButton)
        contentView.addSubview(infoImageView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            sampleReadButton.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 16),
            sampleReadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sampleReadButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            sampleReadButton.heightAnchor.constraint(equalToConstant: 40),
            
            wishlistButton.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 16),
            wishlistButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            wishlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wishlistButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoLabel.topAnchor.constraint(equalTo: sampleReadButton.bottomAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: wishlistButton.trailingAnchor, constant: -20),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 10),
            
            infoImageView.leadingAnchor.constraint(equalTo: sampleReadButton.leadingAnchor),
            infoImageView.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            infoImageView.widthAnchor.constraint(equalToConstant: 18),
            infoImageView.heightAnchor.constraint(equalToConstant: 18),
            
            bottomSeparator.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
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


