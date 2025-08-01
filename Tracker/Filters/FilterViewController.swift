//
//  FilterViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 01.08.2025.
//

import UIKit

final class FilterViewController: UIViewController {

    // MARK: - Private Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filters_title", comment: "Заголовок экрана фильтров")
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let filters: [String] = [
        NSLocalizedString("filters_all", comment: "Все трекеры"),
        NSLocalizedString("filters_today", comment: "Трекеры на сегодня"),
        NSLocalizedString("filters_completed", comment: "Завершённые"),
        NSLocalizedString("filters_incompleted", comment: "Незавершённые")
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(stackView)

        for (index, title) in filters.enumerated() {
            let isLast = index == filters.count - 1
            let row = makeFilterRow(title: title, isLast: isLast)
            stackView.addArrangedSubview(row)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func makeFilterRow(title: String, isLast: Bool) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: 75).isActive = true

        let label = UILabel()
        label.text = title
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])

        // 🔧 Добавим разделитель снизу, но не для последней ячейки
        if !isLast {
            let separator = UIView()
            separator.backgroundColor = .ypGray
            separator.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(separator)

            NSLayoutConstraint.activate([
                separator.heightAnchor.constraint(equalToConstant: 0.5),
                separator.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: row.bottomAnchor)
            ])
        }

        return row
    }

    private func makeSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .ypGray
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: container.topAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
}
