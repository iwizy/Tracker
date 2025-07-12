//
//  AppDelegate.swift
//  Tracker
//
//  AppDeligate

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    var isCoreDataReady = false
    lazy var trackerStore: TrackerStore? = nil

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        print("loadPersistentStores: Начало загрузки")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("❌ Ошибка загрузки persistent store: \(error.localizedDescription)")
                print("Не удалось загрузить CoreData: \(error), \(error.userInfo)")
            } else {
                self.isCoreDataReady = true
                self.trackerStore = TrackerStore(context: container.viewContext)
                print("Persistent store загружен. TrackerStore готов")
            }
        }
        return container
    }()


}

