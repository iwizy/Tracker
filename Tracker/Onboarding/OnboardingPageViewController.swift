//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 21.07.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Public Properties

    var model: OnboardingModel?

    // MARK: - Initializers

    init(model: OnboardingModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.model = nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // временно
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupViews() {
    }

    private func setupConstraints() {
    }
}
