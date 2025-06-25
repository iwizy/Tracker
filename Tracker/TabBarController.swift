//
//  TabBarController.swift
//  Tracker
//
//  Класс ТабБара

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    // Метод вызывается при изменении размеров view.
    // Здесь добавляется верхняя граница к таббару.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTopBorderToTabBar()
    }
    
    // MARK: - Private Methods
    
    // Настраивает контроллеры вкладок (Трекеры и Статистика).
    private func setupTabs() {
        // Создаём контроллер трекеров
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_trackers"),
            tag: 0)
        
        // Создаём контроллер статистики
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_statistics"),
            tag: 1)
        
        // Оборачиваем контроллеры в UINavigationController
        viewControllers = [
            UINavigationController(rootViewController: trackersVC),
            UINavigationController(rootViewController: statisticsVC)
        ]
    }
    
    // Настраивает внешний вид таббара (цвет фона и скролл-эффекты).
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "YPWhite")
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    // Добавляет верхнюю границу к таббару — светло-серую линию высотой 1pt.
    private func addTopBorderToTabBar() {
        let lineHeight: CGFloat = 1
        let lineView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tabBar.bounds.width,
                height: lineHeight)
        )
        lineView.backgroundColor = UIColor(named: "YPLightGray")
        lineView.tag = 999
        
        // Добавляем линию, если она ещё не добавлена
        if tabBar.viewWithTag(999) == nil {
            tabBar.addSubview(lineView)
        }
    }
}
