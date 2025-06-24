//
//  TrackerCell.swift
//  Tracker
//
//  Класс ячейки трекера

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCell"

    var onToggle: (() -> Void)?

    private let cardView = UIView()
    private let emojiBackgroundView = UIView()
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
        let background = UIColor(named: tracker.color) ?? UIColor(hex: tracker.color)

        cardView.backgroundColor = background
        emojiBackgroundView.backgroundColor = background.withAlphaComponent(0.3)
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        counterLabel.text = "\(count) \(pluralizedDay(count))"

        let iconName = isCompleted ? "checkmark" : "plus"
        toggleButton.setImage(UIImage(systemName: iconName), for: .normal)
        toggleButton.tintColor = .white
        toggleButton.backgroundColor = isCompleted ? background.withAlphaComponent(0.3) : background
    }

    private func setupUI() {
        [cardView, counterLabel, toggleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [emojiBackgroundView, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        emojiBackgroundView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        emojiLabel.font = .systemFont(ofSize: 16)
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left
        counterLabel.font = .systemFont(ofSize: 13)
        counterLabel.textColor = UIColor(named: "YPBlack")

        emojiBackgroundView.layer.cornerRadius = 12
        emojiBackgroundView.layer.masksToBounds = true

        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true

        toggleButton.layer.cornerRadius = 17
        toggleButton.layer.masksToBounds = true
        toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),

            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 34),
            toggleButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    @objc private func toggleTapped() {
        onToggle?()
    }

    private func pluralizedDay(_ count: Int) -> String {
        let rem10 = count % 10
        let rem100 = count % 100
        if rem100 >= 11 && rem100 <= 14 { return "дней" }
        switch rem10 {
        case 1: return "день"
        case 2...4: return "дня"
        default: return "дней"
        }
    }
}
