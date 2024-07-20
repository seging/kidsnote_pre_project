//
//  RatingCell.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/19/24.
//

import UIKit

class RatingCell: UITableViewCell {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "평점 및 리뷰"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16) // 폰트 크기와 스타일 조정
        
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right") // 화살표 이미지 설정
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .selectedTab // 이미지 색상 설정
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overallRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalRatingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .naviTint
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private var starImageViews: [UIImageView] = []
    private var starLabels: [UILabel] = []
    private var starProgressViews: [UIProgressView] = []
    private let filledStarImage = UIImage(systemName: "star.fill")
    private let emptyStarImage = UIImage(systemName: "star")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let ratingView:UIView = UIView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .background
        contentView.addSubview(headerLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(ratingView)
        ratingView.addSubview(overallRatingLabel)
        ratingView.addSubview(totalRatingCountLabel)
        
        // 이미지 높이 조정
        
        for _ in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = emptyStarImage
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.tintColor = .selectedTab
            ratingView.addSubview(starImageView)
            starImageViews.append(starImageView)
            
            let starLabel = UILabel()
            starLabel.font = UIFont.systemFont(ofSize: 10)
            starLabel.translatesAutoresizingMaskIntoConstraints = false
            ratingView.addSubview(starLabel)
            starLabels.append(starLabel)
            
            let starProgressView = UIProgressView(progressViewStyle: .default)
            starProgressView.progressTintColor = .selectedTab
            starProgressView.trackTintColor = .naviLine
            starProgressView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(starProgressView)
            starProgressViews.append(starProgressView)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.heightAnchor.constraint(equalToConstant: 20),
            
            arrowImageView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 8),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            
            ratingView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            
            overallRatingLabel.topAnchor.constraint(equalTo: ratingView.topAnchor, constant: -14),
            overallRatingLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            overallRatingLabel.heightAnchor.constraint(equalTo: ratingView.heightAnchor, multiplier: 0.7),
            
            
        ])
        
        for i in 0..<5 {
            NSLayoutConstraint.activate([
                starImageViews[i].topAnchor.constraint(equalTo: overallRatingLabel.bottomAnchor, constant: -10),
                starImageViews[i].leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: CGFloat(i*15)),
                starImageViews[i].widthAnchor.constraint(equalToConstant: 14),
                starImageViews[i].heightAnchor.constraint(equalToConstant: 14),
                
//
                starLabels[i].topAnchor.constraint(equalTo: ratingView.topAnchor, constant: CGFloat(i * 16)),
                starLabels[i].leadingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 16),
                starLabels[i].widthAnchor.constraint(equalToConstant: 10),
                starLabels[i].heightAnchor.constraint(equalToConstant: 8),
                
                starProgressViews[i].centerYAnchor.constraint(equalTo: starLabels[i].centerYAnchor),
                starProgressViews[i].leadingAnchor.constraint(equalTo: starLabels[i].trailingAnchor, constant: 8),
                starProgressViews[i].trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                starProgressViews[i].heightAnchor.constraint(equalToConstant: 8)
                
            ])
        }
        
        NSLayoutConstraint.activate([
            starImageViews[4].trailingAnchor.constraint(equalTo: ratingView.trailingAnchor),
            totalRatingCountLabel.topAnchor.constraint(equalTo: starImageViews.first!.bottomAnchor ,constant: -15),
            totalRatingCountLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            totalRatingCountLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor),
            totalRatingCountLabel.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor),
            
        ])
        
        
    }
    
    func configure(rating: Double, ratingCount: Int) {
        overallRatingLabel.text = String(format: "%.1f", rating)
        totalRatingCountLabel.text = "평점 \(ratingCount)개"
        
        self.setRating(Float(rating))
        var remainingRating = Float(rating) * Float(ratingCount)
            var starCounts = [Int](repeating: 0, count: 5)
            
            for i in 0..<5 {
                let starValue = 5 - i
                if remainingRating >= Float(starValue) * Float(ratingCount) {
                    starCounts[i] = ratingCount
                    remainingRating -= Float(starValue) * Float(ratingCount)
                } else {
                    starCounts[i] = Int(remainingRating / Float(starValue))
                    remainingRating -= Float(starCounts[i] * starValue)
                }
            }
            
            let totalRatings = starCounts.reduce(0, +)
            
            for i in 0..<5 {
                starLabels[i].text = "\(5 - i)"
                if totalRatings > 0 {
                    starProgressViews[i].setProgress(Float(starCounts[i]) / Float(totalRatings), animated: false)
                } else {
                    starProgressViews[i].setProgress(0.0, animated: false)
                }
            }
    }
    
    func setRating(_ rating: Float) {
            let roundedRating = Int(rating)
            let fractionalPart = rating - Float(roundedRating)

            for (index, imageView) in starImageViews.enumerated() {
                imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 기존의 색칠된 레이어 제거

                if index < roundedRating {
                    imageView.image = filledStarImage
                    
                } else if index == roundedRating && fractionalPart > 0 {
                    imageView.image = emptyStarImage
                    
                    let partialLayer = CALayer()
                    partialLayer.backgroundColor = UIColor.selectedTab.cgColor
                    partialLayer.frame = CGRect(x: 0, y: 0, width: imageView.bounds.width * CGFloat(fractionalPart), height: imageView.bounds.height)
                    imageView.layer.addSublayer(partialLayer)
                    imageView.layer.mask = imageView.layer
                } else {
                    imageView.image = emptyStarImage
                    imageView.tintColor = .gray
                }
            }
        }
}



