//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alexander Agafonov on 07.07.2025.
//

import Foundation
import CoreData

final class TrackerStore: NSObject {
    
    var exposedContext: NSManagedObjectContext {
        context
    }

    // MARK: - Public Properties

    private(set) var trackers: [Tracker] = []

    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<TrackerCoreData>

    // MARK: - Initializer

    init(context: NSManagedObjectContext) {
        self.context = context

        // Запрос всех трекеров, отсортированных по имени
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // NSFetchedResultsController без секций и кэша
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        fetchedResultsController.delegate = self

        // Первичная загрузка данных
        do {
            try fetchedResultsController.performFetch()
            updateTrackers()
        } catch {
            print("❌ Ошибка загрузки трекеров: \(error)")
        }
    }

    // MARK: - Public Methods

    /// Добавление нового трекера в Core Data
    func addTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCD = TrackerCoreData(context: context)
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.color = tracker.color
        trackerCD.emoji = tracker.emoji
        trackerCD.schedule = tracker.schedule as NSArray
        trackerCD.category = category
        saveContext()
    }

    /// Возвращает актуальный список трекеров
    func getTrackers() -> [Tracker] {
        trackers
    }

    // MARK: - Private Methods

    /// Обновляет массив trackers из текущих данных FRC
    private func updateTrackers() {
        guard let objects = fetchedResultsController.fetchedObjects else { return }

        trackers = objects.compactMap { trackerCD in
            guard
                let id = trackerCD.id,
                let name = trackerCD.name,
                let color = trackerCD.color,
                let emoji = trackerCD.emoji,
                let rawSchedule = trackerCD.schedule as? [String]
            else {
                return nil
            }

            let validSchedule = rawSchedule.compactMap { WeekDay(rawValue: $0) }
            guard validSchedule.count == rawSchedule.count else {
                print("Некорректные значения расписания в Core Data для трекера \(trackerCD.name ?? "без имени")")
                return nil
            }


            return Tracker(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: rawSchedule
            )
        }
    }

    /// Сохраняет контекст Core Data
    private func saveContext() {
        assert(context.persistentStoreCoordinator?.persistentStores.isEmpty == false,
               "Контекст не привязан к persistent store!")
        do {
            try context.save()
            print("Контекст успешно сохранён")
        } catch {
            print("Ошибка сохранения контекста: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTrackers()
    }
}
