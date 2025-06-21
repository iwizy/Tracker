//
//  TabBarController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 21.06.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTopBorderToTabBar()
    }
    
    private func setupTabs() {
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_trackers"),
            tag: 0)
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_statistics"),
            tag: 1)
        
        // Можно обернуть в UINavigationController, если нужно
        viewControllers = [
            UINavigationController(rootViewController: trackersVC),
            UINavigationController(rootViewController: statisticsVC)
        ]
    }
    
    private func addTopBorderToTabBar() {
        let lineHeight: CGFloat = 1
        let lineView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tabBar.bounds.width,
                height: lineHeight))
        lineView.backgroundColor = UIColor(named: "YPLightGray")
        lineView.tag = 999
        
        if tabBar.viewWithTag(999) == nil {
            tabBar.addSubview(lineView)
        }
    }
}
