//
//  CustomSearchView.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/18/24.
//

import UIKit

class CustomSearchView: UIView, UITextFieldDelegate {
    
    let searchBar:UITextField = UITextField()
    let clearButton:UIButton = UIButton()
    var searchBarWidth: CGFloat!
    let clearButtonWidth: CGFloat = 50
    weak var delegate: CustomSearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        searchBar.delegate = self
        searchBar.placeholder = "Play 북에서 검색"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.naviTint
                ]
                searchBar.attributedPlaceholder = NSAttributedString(string: "Play 북에서 검색", attributes: placeholderAttributes)
        searchBar.borderStyle = .none
        searchBar.returnKeyType = .search
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchBar.textColor = .naviTint
        searchBar.frame = CGRect(x: 0, y: 0, width: self.frame.width - clearButtonWidth, height: self.frame.height)
        
        if let clearImage = UIImage(systemName: "xmark") {
            clearButton.setImage(clearImage, for: .normal)
            clearButton.tintColor = .naviTint
        }
        
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.isHidden = true // 초기에는 버튼을 숨김
        clearButton.frame = CGRect(x: searchBar.frame.maxX, y: 0, width: clearButtonWidth, height: self.frame.height)
        
        addSubview(searchBar)
        addSubview(clearButton)
        
        searchBarWidth = self.frame.width - clearButtonWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = CGRect(x: 0, y: 0, width: searchBarWidth, height: self.frame.height)
        clearButton.frame = CGRect(x: searchBar.frame.maxX, y: 0, width: clearButtonWidth, height: self.frame.height)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            clearButton.isHidden = false
            animateSearchBar(expand: false)
        } else {
            clearButton.isHidden = true
            animateSearchBar(expand: true)
        }
        delegate?.customSearchView(self, textDidChange: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.customSearchViewDidSearch(self, query: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
    
    @objc func clearButtonTapped() {
        searchBar.text = ""
        textFieldDidChange(searchBar)
        delegate?.customSearchViewDidClear(self)
    }
    
    func animateSearchBar(expand: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.searchBarWidth = expand ? self.frame.width - self.clearButtonWidth : self.frame.width - self.clearButtonWidth
            self.layoutSubviews()
        }
    }
}

protocol CustomSearchViewDelegate: AnyObject {
    func customSearchView(_ searchView: CustomSearchView, textDidChange searchText: String?)
    func customSearchViewDidClear(_ searchView: CustomSearchView)
    func customSearchViewDidSearch(_ searchView: CustomSearchView, query: String)
}
