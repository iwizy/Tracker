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

    // MARK: - Private Properties

    private let maxCategoryNameLength = 38

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.tintColor = UIColor(resource: .ypGray)
        textField.backgroundColor = UIColor(resource: .background)
        textField.layer.cornerRadius = 16
        textField.setLeftPaddingPoints(16)
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(errorLabel)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),

            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func textFieldChanged() {
        guard let text = textField.text else { return }

        let trimmed = text.trimmingCharacters(in: .whitespaces)
        let isTooLong = trimmed.count > maxCategoryNameLength
        let hasText = !trimmed.isEmpty && !isTooLong

        errorLabel.isHidden = !isTooLong
        doneButton.isEnabled = hasText
        doneButton.backgroundColor = hasText ? .ypBlack : .ypGray
    }

    @objc private func doneButtonTapped() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces),
              !text.isEmpty,
              text.count <= maxCategoryNameLength else { return }

        onSave?(text)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Проверка будущей длины текста
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // Покажем ошибку, если слишком длинно (вставкой или копипастом)
        errorLabel.isHidden = updatedText.count <= maxCategoryNameLength
        return updatedText.count <= maxCategoryNameLength
    }
}

// MARK: - Helpers

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
