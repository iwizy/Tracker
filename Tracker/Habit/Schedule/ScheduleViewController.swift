//
//  ScheduleViewController.swift
//  Tracker
//
//  Класс экрана выбора расписания

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    /// Множество выбранных дней недели
    var selectedDays: Set<WeekDay> = []
    
    /// Замыкание, вызываемое при нажатии кнопки "Готово"
    var onScheduleSelected: ((Set<WeekDay>) -> Void)?
    
    // MARK: - Private Properties
    /// Заголовок экрана
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    /// Таблица с днями недели
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    /// Кнопка "Готово"
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    /// Контейнер с фоном под таблицей
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .background)
        view.layer.cornerRadius = 16
        return view
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        setupLayout()
        setupDoneButtonConstraints()
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }
    
    // MARK: - Private Methods
    
    /// Настройка делегатов и регистрации ячеек таблицы
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
    }
    
    /// Расстановка элементов интерфейса
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Контейнер под таблицу
            backgroundContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            backgroundContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundContainerView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDay.allCases.count) * 75),
            
            // Таблица
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
    
    /// Отдельная настройка констрейнтов кнопки (дублирующая, если понадобится отдельно вызывать)
    private func setupDoneButtonConstraints() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    /// Обработка нажатия на кнопку "Готово"
    @objc private func doneButtonTapped() {
        onScheduleSelected?(selectedDays)
        dismiss(animated: true)
    }
    
    /// Обработка переключателя включения/выключения дня
    @objc private func switchToggled(_ sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Количество строк равно количеству дней недели
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    /// Высота каждой строки — 75pt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    /// Настройка ячейки с днём недели
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let day = WeekDay.allCases[indexPath.row]
        let isLast = indexPath.row == WeekDay.allCases.count - 1
        
        cell.configure(with: day, isOn: selectedDays.contains(day), isLast: isLast)
        cell.toggleSwitch.tag = indexPath.row
        cell.toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        return cell
    }
}
