//
//  FilterViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 01.08.2025.
//

import UIKit

enum TrackerFilterType: Int {
    case all
    case today
    case completed
    case incompleted
}

protocol FilterSelectionDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilterType)
}

final class FilterViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: FilterSelectionDelegate?

    // MARK: - Private Properties

    private let filters: [String] = [
        NSLocalizedString("filters_all", comment: "Все трекеры"),
        NSLocalizedString("filters_today", comment: "Трекеры на сегодня"),
        NSLocalizedString("filters_completed", comment: "Завершённые"),
        NSLocalizedString("filters_incompleted", comment: "Незавершённые")
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filters_title", comment: "Заголовок экрана фильтров")
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .ypLightGray
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
        setupConstraints()
        setupTable()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(filters.count * 75))
        ])
    }

    private func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = filters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = title
        config.textProperties.color = .ypBlack
        config.textProperties.font = .systemFont(ofSize: 17)
        cell.contentConfiguration = config
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedFilter = TrackerFilterType(rawValue: indexPath.row) else { return }
        delegate?.didSelectFilter(selectedFilter)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
