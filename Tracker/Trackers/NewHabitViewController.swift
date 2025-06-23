import UIKit

final class NewHabitViewController: UIViewController {

    // MARK: - UI Elements

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
        textField.backgroundColor = UIColor(named: "Background")
        textField.tintColor = UIColor(named: "YPGray")
        textField.layer.cornerRadius = 16
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        return textField
    }()

    private let optionsBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Background")
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
        label.textColor = UIColor(named: "YPGray")
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
        imageView.tintColor = UIColor(named: "YPGray")
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
        view.backgroundColor = UIColor(named: "YPGray")
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
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let scheduleValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YPGray")
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

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "YPRed")?.cgColor
        button.layer.cornerRadius = 16
        return button
    }()

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "YPGray")
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()

    // MARK: - Properties

    private var selectedDays: Set<WeekDay> = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(optionsBackgroundView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)

        
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            optionsBackgroundView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            optionsBackgroundView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            optionsBackgroundView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
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

            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(openSchedule), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func openSchedule() {
        let vc = ScheduleViewController()
        vc.selectedDays = selectedDays
        vc.onScheduleSelected = { [weak self] selected in
            self?.selectedDays = selected

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
}

// MARK: - Padding Helper

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}
