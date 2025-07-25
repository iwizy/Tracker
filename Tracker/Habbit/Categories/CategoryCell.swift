//
//  CategoryCell.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    static let reuseIdentifier = "CategoryCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .ypBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        nil
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
