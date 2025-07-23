//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alexander Agafonov on 07.07.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func fetchCategories() throws -> [TrackerCategory] {
        // ⚠️ Здесь заглушка — должен быть реальный fetch из Core Data
        return []
    }

    func saveCategory(named name: String) throws {
        // ⚠️ Реализация сохранения категории в Core Data
    }
}
