//
//  CustomSegmentedButton.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class CustomSegmentedButton: UIButton {
    
    private let highlightOverlay: UIView
    
    private var isAnimating: Bool = false
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted && !isAnimating {
                showHighlightOverlay()
            } else if !isHighlighted {
                hideHighlightOverlay()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        highlightOverlay = UIView(frame: frame)
        highlightOverlay.backgroundColor = UIColor.selectedTab.withAlphaComponent(0.5)
        highlightOverlay.isHidden = true
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        highlightOverlay = UIView()
        highlightOverlay.backgroundColor = UIColor.selectedTab.withAlphaComponent(0.5)
        highlightOverlay.isHidden = true
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        highlightOverlay.frame = bounds
        highlightOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(highlightOverlay)
        self.clipsToBounds = true
        self.backgroundColor = .clear
    }
    
    private func showHighlightOverlay() {
        highlightOverlay.isHidden = false
        highlightOverlay.transform = CGAffineTransform(scaleX: 0.0, y: 1.0)
        UIView.animate(withDuration: 0.3, animations: {
            self.highlightOverlay.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            self.isAnimating = false
        }
    }
    
    private func hideHighlightOverlay() {
        self.highlightOverlay.isHidden = true
        self.isAnimating = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !self.bounds.contains(location) {
            self.isHighlighted = false
        }
    }
}

