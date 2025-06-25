//
//  TrackerCell.swift
//  Tracker
//
//  Класс ячейки трекера

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCell"

    var onToggle: (() -> Void)?

    // MARK: - UI

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPWhite")
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "YPWhite")
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        let background = UIColor(named: tracker.color) ?? UIColor(hex: tracker.color)

        cardView.backgroundColor = background
        emojiBackgroundView.backgroundColor = UIColor(named: "YPWhite")?.withAlphaComponent(0.3)
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        counterLabel.text = "\(count) \(pluralizedDay(count))"

        let iconName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(
            systemName: iconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        )

        toggleButton.setImage(image, for: .normal)
        toggleButton.tintColor = .white
        toggleButton.backgroundColor = isCompleted ? background.withAlphaComponent(0.3) : background
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(cardView)
        contentView.addSubview(counterLabel)
        contentView.addSubview(toggleButton)

        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)
    }

    private func setupConstraints() {
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

            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            
            toggleButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 34),
            toggleButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    // MARK: - Actions

    @objc private func toggleTapped() {
        onToggle?()
    }

    // MARK: - Helpers

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
