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
    private let tableViewContainer = UIView()
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor(resource: .background)
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        return table
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.backgroundColor = .ypWhite
        setupViews()
        setupConstraints()
        setupTable()
        bindViewModel()
        viewModel.fetchCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableViewContainer)
        view.addSubview(addButton)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.layer.cornerRadius = 16
        
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        tableViewHeightConstraint = tableViewContainer.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableViewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewHeightConstraint!, // сохраняем ссылку
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            
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
            guard let self = self else { return }
            
            let hasCategories = !self.viewModel.categories.isEmpty
            self.tableView.isHidden = !hasCategories
            self.emptyImageView.isHidden = hasCategories
            self.emptyLabel.isHidden = hasCategories
            
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                self.tableView.layoutIfNeeded()
                self.tableViewHeightConstraint?.constant = self.tableView.contentSize.height
            }
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
        let isLast = indexPath.row == viewModel.categories.count - 1
        cell.configure(with: category.title, isSelected: isSelected, isLast: isLast)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
