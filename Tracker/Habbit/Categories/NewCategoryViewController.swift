//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Alexander Agafonov on 23.07.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController {

    // MARK: - Public Properties

    var onSave: ((String) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Новая категория"
        // Пока просто пустой экран, заглушка для устранения ошибки
    }
}
