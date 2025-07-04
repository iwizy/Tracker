//
//  ColorCell.swift
//  Tracker
//
//  Created by Alexander Agafonov on 04.07.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with color: UIColor) {
        contentView.backgroundColor = color
    }
}
