//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alexander Agafonov on 07.07.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore {

    // MARK: - Singleton

    static let shared = TrackerCategoryStore()

    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    
    // MARK: - Internal Accessors

    /// Только для использования в других Store
    var internalContextForStores: NSManagedObjectContext {
        context
    }

    // MARK: - Initializer

    private init() {
        let container = NSPersistentContainer(name: "Tracker")
        var loadError: Error?

        container.loadPersistentStores { _, error in
            if let error = error {
                loadError = error
            }
        }

        if let error = loadError {
            print("⚠️ Ошибка инициализации TrackerCategoryStore: \(error.localizedDescription)")
            assertionFailure("Не удалось загрузить Core Data Stack")
        }

        self.context = container.viewContext
    }

    // MARK: - Public Methods

    func fetchCategories() throws -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let results = try context.fetch(request)

        return results.compactMap { coreDataCategory in
            guard let title = coreDataCategory.title else {
                return nil
            }

            let trackers: [Tracker] = (coreDataCategory.trackers?.allObjects as? [TrackerCoreData])?.compactMap { trackerCD in
                guard
                    let id = trackerCD.id,
                    let name = trackerCD.name,
                    let color = trackerCD.color,
                    let emoji = trackerCD.emoji,
                    let schedule = trackerCD.schedule as? [String]
                else { return nil }

                return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
            } ?? []

            return TrackerCategory(title: title, trackers: trackers)
        }
    }
    
    func fetchCategoryCoreData(with title: String) throws -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    func saveCategory(named name: String) throws {
        let entity = TrackerCategoryCoreData(context: context)
        entity.title = name
        try context.save()
    }
}
