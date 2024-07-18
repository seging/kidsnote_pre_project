//
//  CustomSegmentedButton.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class CustomSegmentedButton: UIButton {
    
    private let highlightLayer: CAShapeLayer = CAShapeLayer()
    private var isAnimating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        highlightLayer.fillColor = UIColor.selectedTab.withAlphaComponent(0.3).cgColor
        highlightLayer.isHidden = true
        self.layer.addSublayer(highlightLayer)
        self.clipsToBounds = true
        self.backgroundColor = .background
    }
    
    private func animateHighlightLayer() {
        guard !isAnimating else { return }
        isAnimating = true
        highlightLayer.isHidden = false
        let startPath = UIBezierPath(ovalIn: CGRect(x: bounds.midX - 1, y: bounds.midY - 1, width: 2, height: 2)).cgPath
        let endPath = UIBezierPath(ovalIn: bounds.insetBy(dx: -bounds.width * 0.8, dy: -bounds.height * 2)).cgPath
        
        highlightLayer.path = startPath
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = startPath
        pathAnimation.toValue = endPath
        pathAnimation.duration = 0.4
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.3
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        
        highlightLayer.add(pathAnimation, forKey: "pathAnimation")
        highlightLayer.add(opacityAnimation, forKey: "opacityAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
        }
    }
    
    private func hideHighlightLayer() {
        guard !isAnimating else { return }
        isAnimating = true
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.3
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        highlightLayer.add(opacityAnimation, forKey: "opacityAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.highlightLayer.isHidden = true
            self.isAnimating = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateHighlightLayer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !self.bounds.contains(location) {
            hideHighlightLayer()
        } else {
            animateHighlightLayer()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isAnimating = false
        hideHighlightLayer()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        hideHighlightLayer()
    }
}



