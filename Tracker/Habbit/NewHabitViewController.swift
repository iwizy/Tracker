//
//  NewHabitViewController.swift
//  Tracker
//
//  Класс экрана создания привычки

import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    private var errorBottomConstraint: NSLayoutConstraint?
    private var nameToOptionsConstraint: NSLayoutConstraint?
    
    private var emojiHeightConstraint: NSLayoutConstraint?
    private var colorHeightConstraint: NSLayoutConstraint?
    
    private var selectedDays: Set<WeekDay> = []
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let colorNames = (1...18).map { "ColorSection\($0)" }
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(resource: .background)
        textField.tintColor = UIColor(resource: .ypGray)
        textField.layer.cornerRadius = 16
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor(resource: .ypRed)
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.alpha = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let optionsBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .background)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let categoryValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .ypGray)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private let categoryArrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(resource: .ypGray)
        return imageView
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(resource: .ypGray)
        return view
    }()
    
    private let scheduleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.textColor = UIColor(resource: .ypBlack)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let scheduleValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .ypGray)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let scheduleArrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private let scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collection.isScrollEnabled = false
        return collection
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collection.isScrollEnabled = false
        return collection
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .ypRed).cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .ypGray)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
        nameTextField.delegate = self
        scrollView.alwaysBounceVertical = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.keyboardDismissMode = .interactive

        view.addSubview(titleLabel) // 🔧 теперь titleLabel вне scrollView (🆕)

        // ❌ Удалено: теперь titleLabel не внутри scrollView
        // contentView.addSubview(titleLabel)

        contentView.addSubview(nameFieldStack)
        nameFieldStack.addArrangedSubview(nameTextField)
        nameFieldStack.addArrangedSubview(errorLabel)

        contentView.addSubview(optionsBackgroundView)
        optionsBackgroundView.addSubview(categoryArrow)
        optionsBackgroundView.addSubview(categoryButton)
        categoryStackView.addArrangedSubview(categoryLabel)
        categoryStackView.addArrangedSubview(categoryValueLabel)
        optionsBackgroundView.addSubview(categoryStackView)
        optionsBackgroundView.addSubview(separator)
        scheduleStackView.addArrangedSubview(scheduleLabel)
        scheduleStackView.addArrangedSubview(scheduleValueLabel)
        optionsBackgroundView.addSubview(scheduleStackView)
        optionsBackgroundView.addSubview(scheduleArrow)
        optionsBackgroundView.addSubview(scheduleButton)

        contentView.addSubview(emojiLabel)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCollectionView)

        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
    }
    
    private func setupConstraints() {
        let emojiRows = ceil(Double(emojis.count) / 6.0)
        let colorRows = ceil(Double(colorNames.count) / 6.0)
        let itemHeight: CGFloat = 52
        let spacing: CGFloat = 12
        let emojiHeight = (itemHeight * CGFloat(emojiRows)) + (spacing * (CGFloat(emojiRows) - 1))
        let colorHeight = (itemHeight * CGFloat(colorRows)) + (spacing * (CGFloat(colorRows) - 1))

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameFieldStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            nameFieldStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameFieldStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            optionsBackgroundView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            optionsBackgroundView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            optionsBackgroundView.topAnchor.constraint(equalTo: nameFieldStack.bottomAnchor, constant: 24),
            optionsBackgroundView.heightAnchor.constraint(equalToConstant: 150),

            categoryStackView.leadingAnchor.constraint(equalTo: optionsBackgroundView.leadingAnchor, constant: 16),
            categoryStackView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),

            categoryArrow.trailingAnchor.constraint(equalTo: optionsBackgroundView.trailingAnchor, constant: -16),
            categoryArrow.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),

            categoryButton.leadingAnchor.constraint(equalTo: optionsBackgroundView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: optionsBackgroundView.trailingAnchor),
            categoryButton.topAnchor.constraint(equalTo: optionsBackgroundView.topAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),

            separator.leadingAnchor.constraint(equalTo: optionsBackgroundView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: optionsBackgroundView.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),

            scheduleStackView.leadingAnchor.constraint(equalTo: optionsBackgroundView.leadingAnchor, constant: 16),
            scheduleStackView.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),

            scheduleArrow.trailingAnchor.constraint(equalTo: optionsBackgroundView.trailingAnchor, constant: -16),
            scheduleArrow.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),

            scheduleButton.leadingAnchor.constraint(equalTo: optionsBackgroundView.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: optionsBackgroundView.trailingAnchor),
            scheduleButton.bottomAnchor.constraint(equalTo: optionsBackgroundView.bottomAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),

            emojiLabel.topAnchor.constraint(equalTo: optionsBackgroundView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: emojiHeight),

            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 8),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: colorHeight),

            buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])

        errorBottomConstraint = optionsBackgroundView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32)
        nameToOptionsConstraint = optionsBackgroundView.topAnchor.constraint(equalTo: nameFieldStack.bottomAnchor, constant: 24)

        nameToOptionsConstraint?.isActive = true
        errorBottomConstraint?.isActive = false
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(openSchedule), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(nameFieldChanged), for: .editingChanged)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func openSchedule() {
        let vc = ScheduleViewController()
        vc.selectedDays = selectedDays
        vc.onScheduleSelected = { [weak self] selected in
            self?.selectedDays = selected
            self?.updateCreateButtonState()
            
            let allDays = Set(WeekDay.allCases)
            let text: String
            
            if selected == allDays {
                text = "Каждый день"
            } else {
                text = selected
                    .sorted { $0.order < $1.order }
                    .map { $0.shortName }
                    .joined(separator: ", ")
            }
            
            self?.scheduleValueLabel.text = text
        }
        present(vc, animated: true)
    }
    
    @objc private func nameFieldChanged() {
        updateCreateButtonState()
        
        let trimmedText = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isAtLimit = trimmedText.count >= 38
        
        if isAtLimit {
            errorLabel.isHidden = false
            errorBottomConstraint?.isActive = true
            nameToOptionsConstraint?.isActive = false
        } else {
            errorLabel.isHidden = true
            errorBottomConstraint?.isActive = false
            nameToOptionsConstraint?.isActive = true
        }

        UIView.animate(withDuration: 0.25) {
            self.errorLabel.alpha = isAtLimit ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 20, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func updateCreateButtonState() {
        let nameIsEmpty = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let hasSchedule = !selectedDays.isEmpty
        createButton.isEnabled = !nameIsEmpty && hasSchedule
        createButton.backgroundColor = createButton.isEnabled ? UIColor(resource: .ypBlack) : UIColor(resource: .ypGray)
    }
    
    @objc private func createTapped() {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty,
              !selectedDays.isEmpty else {
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: name,
            color: "ColorSection15",
            emoji: "🐱",
            schedule: selectedDays.map { $0.rawValue }
        )
        onCreateTracker?(tracker)
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}

extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else if collectionView == colorCollectionView {
            return colorNames.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            let emoji = emojis[indexPath.item]
            cell.configure(with: emoji)
            return cell
        } else if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            let colorName = colorNames[indexPath.item]
            cell.configure(with: UIColor(named: colorName) ?? .gray)
            return cell
        }
        return UICollectionViewCell()
    }
}
