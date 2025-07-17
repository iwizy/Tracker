//
//  EmojiCell.swift
//  Tracker
//
//  Created by Alexander Agafonov on 04.07.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.layer.cornerRadius = 16 
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }

    func setSelected(_ selected: Bool) {
        contentView.backgroundColor = selected
            ? UIColor(resource: .ypLightGray)
            : .clear
    }
}
