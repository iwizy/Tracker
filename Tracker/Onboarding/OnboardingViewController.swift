//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 21.07.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private Properties

    private var pageViewController: UIPageViewController!
    private var pages: [OnboardingModel] = []
    private var currentIndex: Int = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPages()
        setupPageViewController()
    }

    // MARK: - Private Methods

    private func setupPages() {
        // 🆕 Здесь задаются временные данные. Заменим позже при интеграции с макетом.
        pages = [
            OnboardingModel(title: "Трекер привычек", subtitle: "Отслеживайте и улучшайте", imageName: "onboarding1", isLastPage: false),
            OnboardingModel(title: "Аналитика", subtitle: "Следите за прогрессом", imageName: "onboarding2", isLastPage: false),
            OnboardingModel(title: "Вот это технологии!", subtitle: "Начнём!", imageName: "onboarding3", isLastPage: true)
        ]
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        pageViewController.dataSource = self
        pageViewController.delegate = self

        if let firstVC = viewController(at: currentIndex) {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        // constraints для pageViewController.view
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func viewController(at index: Int) -> OnboardingPageViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        let model = pages[index]
        return OnboardingPageViewController(model: model)
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController,
              let currentModel = currentVC.model,
              let index = pages.firstIndex(where: { $0.title == currentModel.title }) else {
            return nil
        }
        let previousIndex = index - 1
        return self.viewController(at: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController,
              let currentModel = currentVC.model,
              let index = pages.firstIndex(where: { $0.title == currentModel.title }) else {
            return nil
        }
        let nextIndex = index + 1
        return self.viewController(at: nextIndex)
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let model = visibleVC.model,
           let index = pages.firstIndex(where: { $0.title == model.title }) {
            currentIndex = index
        }
    }
}
