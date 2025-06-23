//
//  TrackerCell.swift
//  Tracker
//
//  Класс ячейки трекера

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCell"

    var onToggle: (() -> Void)?

    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let counterLabel = UILabel()
    private let toggleButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        counterLabel.text = "\(count) дней"

        toggleButton.setImage(
            UIImage(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle"),
            for: .normal
        )
        toggleButton.tintColor = isCompleted ? .green : .blue
        contentView.backgroundColor = UIColor(hex: tracker.color)
    }

    private func setupUI() {
        [emojiLabel, nameLabel, counterLabel, toggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        emojiLabel.font = .systemFont(ofSize: 24)
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.numberOfLines = 2
        counterLabel.font = .systemFont(ofSize: 13)

        toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            counterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            toggleButton.widthAnchor.constraint(equalToConstant: 34),
            toggleButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    @objc private func toggleTapped() {
        onToggle?()
    }
}
