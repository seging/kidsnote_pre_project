//
//  cu.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class CustomSegmentedControl: UIView {
    private var buttons: [CustomSegmentedButton] = []
    private var selector: UIView!
    private var underline: UIView!
    var selectedSegmentIndex: Int = 0
    var buttonTitles: [String]!
    var textColor: UIColor = .secondaryLabel
    var selectorColor: UIColor = .selectedTab
    var selectorTextColor: UIColor = .selectedTab
    
    var segmentValueChangedHandler: ((Int) -> Void)?
    var textSizes: [CGFloat] = []
    
    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitles
        self.textSizes = buttonTitles.map {
            $0.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]).width - 4
        }
        updateView()
    }
    
    private func updateView() {
        createButtons()
        configureSelector()
        configureUnderline()
        layoutButtons()
    }
    
    private func createButtons() {
        buttons = [CustomSegmentedButton]()
        subviews.forEach({ $0.removeFromSuperview() })
        
        for buttonTitle in buttonTitles {
            let button = CustomSegmentedButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
            buttons.append(button)
            addSubview(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func configureUnderline() {
        underline = UIView()
        underline.backgroundColor = .naviLine
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureSelector() {
        let selectorWidth = textSizes[0]
        selector = UIView(frame: CGRect(x: 0, y: self.frame.height - 4, width: selectorWidth, height: 3))
        selector.backgroundColor = selectorColor
        addSubview(selector)
        applyTopCornerRadius()
    }
    
    private func layoutButtons() {
        let buttonWidth = frame.width / CGFloat(buttonTitles.count)
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: frame.height)
        }
        updateSelectorPosition()
    }
    
    private func updateSelectorPosition() {
        let selectorWidth = textSizes[selectedSegmentIndex]
        let buttonWidth = frame.width / CGFloat(buttonTitles.count)
        let selectorX = buttonWidth * CGFloat(selectedSegmentIndex) + (buttonWidth - selectorWidth) / 2
        
        
        self.selector.frame = CGRect(x: selectorX, y: self.frame.height - 4, width: selectorWidth, height:self.selector.frame.height)
        self.applyTopCornerRadius()
        
    }
    
    @objc private func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                UIView.animate(withDuration: 0.5,animations: {
                    self.selectedSegmentIndex = buttonIndex
                    self.updateSelectorPosition()
                    btn.setTitleColor(self.selectorTextColor, for: .normal)
                    
                }) { (_) in
                    self.segmentValueChangedHandler?(buttonIndex)
                }
                
            }
        }
    }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButtons()
    }
    
    private func applyTopCornerRadius() {
        let path = UIBezierPath(roundedRect: selector.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 12, height: 12))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        selector.layer.mask = mask
    }
}
