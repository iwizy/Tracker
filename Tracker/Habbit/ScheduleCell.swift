//
//  ScheduleCell.swift
//  Tracker
//
//  Кастомная ячейка в таблице для выбора дня недели

import UIKit

final class ScheduleCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleCell"
    // MARK: - Public Properties
    /// Переключатель (вкл/выкл) для выбранного дня
    let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = UIColor(resource: .ypBlue) // Цвет переключателя в активном состоянии
        return toggle
    }()
    
    // MARK: - Private Properties
    /// Метка с названием дня недели
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    /// Разделительная линия внизу ячейки
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .ypGray)
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)
        contentView.addSubview(separatorView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /// Конфигурирует ячейку: название дня, состояние переключателя и отображение разделителя
    func configure(with day: WeekDay, isOn: Bool, isLast: Bool) {
        dayLabel.text = day.rawValue
        toggleSwitch.isOn = isOn
        separatorView.isHidden = isLast
    }
    
    // MARK: - Private Methods
    /// Настройка констрейнтов элементов ячейки
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}
