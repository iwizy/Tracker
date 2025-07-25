//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import Foundation

final class CategoriesViewModel {

    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var onCategoriesChanged: (() -> Void)?
    var selectedCategory: TrackerCategory?

    // MARK: - Private Properties
    private let store = TrackerCategoryStore.shared

    // MARK: - Public Methods
    func fetchCategories() {
        do {
            categories = try store.fetchCategories()
        } catch {
            print("Ошибка при получении категорий: \(error)")
            categories = []
        }
        onCategoriesChanged?()
    }

    func addCategory(named name: String) {
        do {
            try store.saveCategory(named: name)
            fetchCategories()
        } catch {
            print("Ошибка при сохранении категории: \(error)")
        }
    }

    func selectCategory(_ category: TrackerCategory) {
        selectedCategory = category
    }

    func isCategorySelected(_ category: TrackerCategory) -> Bool {
        selectedCategory?.title == category.title
    }
}
