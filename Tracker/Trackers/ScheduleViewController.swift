//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 22.06.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {

    var selectedDays: Set<WeekDay> = []
    var onScheduleSelected: ((Set<WeekDay>) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()


    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack") ?? .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
        view.layer.cornerRadius = 16
        return view
    }()

    var onSave: (([WeekDay]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupLayout()
        setupDoneButtonConstraints()
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(backgroundContainerView)
        backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainerView.addSubview(tableView)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            // Заголовок "Расписание"
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Подложка под таблицу — сразу под заголовком
            backgroundContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            backgroundContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundContainerView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDay.allCases.count) * 75),

            // Таблица внутри подложки
            tableView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor),

            // Кнопка "Готово"
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupDoneButtonConstraints() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func doneButtonTapped() {
        onScheduleSelected?(selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - Table View Delegate & Data Source

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }

        let day = WeekDay.allCases[indexPath.row]
        let isLast = indexPath.row == WeekDay.allCases.count - 1
        cell.configure(with: day, isOn: selectedDays.contains(day), isLast: isLast)
        cell.toggleSwitch.tag = indexPath.row
        cell.toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        return cell
    }

    @objc private func switchToggled(_ sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
