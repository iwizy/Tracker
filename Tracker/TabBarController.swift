//
//  TabBarController.swift
//  Tracker
//
//  Класс ТабБара

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
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
        
        viewControllers = [
            UINavigationController(rootViewController: trackersVC),
            UINavigationController(rootViewController: statisticsVC)
        ]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "YPWhite")

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
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
