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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
