//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import Foundation

final class CategoriesViewModel {

    var categories: [TrackerCategory] = []
    var onCategoriesChanged: (() -> Void)?
    
    private let store = TrackerCategoryStore() // ✅ создаём экземпляр вручную

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
}
