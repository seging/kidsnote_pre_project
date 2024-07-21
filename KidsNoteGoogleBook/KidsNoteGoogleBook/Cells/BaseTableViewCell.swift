//
//  Base.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/21/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseUI() {
        self.selectionStyle = .none
        self.backgroundColor = .background
    }
    
    func createLabel(text: String? = nil, font: UIFont = .systemFont(ofSize: 14), textColor: UIColor = .label, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createImageView(image: UIImage? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, tintColor: UIColor? = nil, cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.tintColor = tintColor
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func createButton(title: String, font: UIFont = .systemFont(ofSize: 14), titleColor: UIColor = .label, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 4, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, tintColor: UIColor = .blue) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = borderWidth
        button.tintColor = tintColor
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createProgressView(progressTintColor: UIColor? = nil, trackTintColor: UIColor? = nil) -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = progressTintColor
        progressView.trackTintColor = trackTintColor
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
