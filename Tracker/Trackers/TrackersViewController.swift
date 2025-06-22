//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 21.06.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add_tracker_icon"), for: .normal)
        return button
    }()
    
    private let navigationButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.backgroundColor = UIColor(hex: "#767680", alpha: 0.12)
        textField.font = .systemFont(ofSize: 17)
        textField.tintColor = UIColor(named: "YPGray")
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .center
        imageView.tintColor = UIColor(named: "YPGray")
        
        // Обёртка вокруг иконки
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        imageView.frame = CGRect(x: 8, y: 4, width: 16, height: 16)
        containerView.addSubview(imageView)
        
        // Установка иконки в поле через контейнер
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let emptyPlaceholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "empty_placeholder"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emptyPlaceholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyPlaceholderImage, emptyPlaceholderLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        navigationButtonContainerView.addSubview(addTrackerButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationButtonContainerView)
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(emptyPlaceholderStack)
        
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Кнопка добавления трекера
            addTrackerButton.leadingAnchor.constraint(equalTo: navigationButtonContainerView.leadingAnchor, constant: -10), // сдвиг влево
            addTrackerButton.centerYAnchor.constraint(equalTo: navigationButtonContainerView.centerYAnchor),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            
            navigationButtonContainerView.widthAnchor.constraint(equalToConstant: 60),
            navigationButtonContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Поле поиска
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Заглушка
            emptyPlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPlaceholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addTrackerButtonTapped() {
        print("Нажата кнопка добавления трекера")
    }
}
