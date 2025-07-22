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
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .lightGray
        control.hidesForSinglePage = true
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPages()
        setupPageViewController()
        setupPageControl()
    }
    
    // MARK: - Private Methods
    
    private func setupPages() {
        pages = [
            OnboardingModel(
                title: "Отслеживайте только то, что хотите",
                imageName: "onboarding_page_1"
            ),
            OnboardingModel(
                title: "Даже если это не литры воды и йога",
                imageName: "onboarding_page_2"
            )
        ]
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndex
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
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
    }
    
    private func viewController(at index: Int) -> OnboardingPageViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        let model = pages[index]
        let vc = OnboardingPageViewController(model: model)
        vc.delegate = self
        return vc
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
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let model = visibleVC.model,
           let index = pages.firstIndex(where: { $0.title == model.title }) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }
}


extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func onboardingDidFinish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        guard let window = view.window else { return }
        let mainVC = TabBarController()
        window.rootViewController = mainVC
    }
}
