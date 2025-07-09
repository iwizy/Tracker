//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexander Agafonov on 07.07.2025.
//

import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Сохраняем выполнение
    func addRecord(_ record: TrackerRecord) {
        let entity = TrackerRecordCoreData(context: context)
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(record.trackerId, forKey: "trackerId")
        entity.setValue(record.date, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print("❌ Failed to save tracker record: \(error)")
        }
    }

    // Удаляем выполнение
    func deleteRecord(trackerId: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerId as CVarArg, date as CVarArg)
        if let results = try? context.fetch(fetchRequest) {
            for record in results {
                context.delete(record)
            }
            try? context.save()
        }
    }

    // Загружаем все записи
    // Получение всех записей о выполненных трекерах
    func getAllRecords() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { record in
                // ✅ Поле trackerId — это UUID, используем напрямую
                guard
                    let trackerId = record.trackerId,
                    let date = record.date
                else { return nil }

                return TrackerRecord(trackerId: trackerId, date: date)
            }
        } catch {
            print("❌ Ошибка загрузки записей: \(error)")
            return []
        }
    }
}
