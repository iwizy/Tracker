//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Private Properties
    
    private let viewModel = CategoriesViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine // 🆕 системные разделители
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 🆕 отступы
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "empty_placeholder"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupTable()
        bindViewModel()
        viewModel.fetchCategories()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableBackgroundView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableBackgroundView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: tableBackgroundView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableBackgroundView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableBackgroundView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableBackgroundView.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -6),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 24),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTable() {
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onCategoriesChanged = { [weak self] in
            print("Категории: \(self?.viewModel.categories.map(\.title) ?? [])")
            guard let self = self else { return }
            let hasCategories = !self.viewModel.categories.isEmpty
            self.tableView.isHidden = !hasCategories
            self.emptyImageView.isHidden = hasCategories
            self.emptyLabel.isHidden = hasCategories
            self.tableView.reloadData()
        }
    }
    
    @objc private func addButtonTapped() {
        let newVC = NewCategoryViewController()
        newVC.onSave = { [weak self] newCategory in
            self?.viewModel.addCategory(named: newCategory)
        }
        present(newVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCell
        else {
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.isCategorySelected(category)

        cell.configure(with: category.title, isSelected: isSelected)
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.categories[indexPath.row]
        viewModel.selectCategory(selected)
        onCategorySelected?(selected)
        tableView.reloadData()
        dismiss(animated: true)
    }
}
