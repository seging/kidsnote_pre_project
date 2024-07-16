//
//  Seg.swift
//  KidsNoteGoogleBook
//
//  Created by 이승기 on 7/16/24.
//

import UIKit

class SegmentedControlCell: UITableViewCell {
    private let customSegmentedControl = CustomSegmentedControl(frame: .zero, buttonTitles: ["eBook", "오디오북"])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(customSegmentedControl)
        customSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            customSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            customSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSegmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }

    func configure(segmentAction: @escaping (Int) -> Void) {
        customSegmentedControl.segmentValueChangedHandler = segmentAction
    }
}


