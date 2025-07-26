//
//  CategoryCell.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    static let reuseIdentifier = "CategoryCell"

    // MARK: - Private UI

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
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .ypGray)
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Configuration

    func configure(with title: String, isSelected: Bool, isLast: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
        separatorView.isHidden = isLast
    }
    
    

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}
