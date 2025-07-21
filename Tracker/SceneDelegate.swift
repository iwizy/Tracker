//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Alexander Agafonov on 19.06.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        if hasSeenOnboarding {
            window.rootViewController = TabBarController()
        } else {
            window.rootViewController = OnboardingViewController()
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}

