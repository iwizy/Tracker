//
//  TrackerSectionHeader.swift
//  Tracker
//
//  Класс категории трекеров

import UIKit

final class TrackerSectionHeader: UICollectionReusableView {
    
    // MARK: - Public Properties
    /// Идентификатор для повторного использования хедера секции
    static let reuseIdentifier = "TrackerSectionHeader"
    
    // MARK: - Private Properties
    /// Заголовок категории трекеров
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "YPBlack") ?? .black
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /// Устанавливает текст заголовка секции
    /// - Parameter title: Название категории трекеров
    func configure(with title: String) {
        titleLabel.text = title
    }
}
