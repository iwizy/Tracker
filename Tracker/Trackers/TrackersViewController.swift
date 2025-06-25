//
//  TrackersViewController.swift
//  Tracker
//
//  Класс экрана списка трекеров

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Public properties
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Привычки", trackers: [])
    ]
    
    var completedTrackers: [TrackerRecord] = []

    // MARK: - Private properties

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .systemBlue
        return picker
    }()

    private let addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add_tracker_icon"), for: .normal)
        return button
    }()

    private let navigationButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()

    private let searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.backgroundColor = UIColor(hex: "#767680", alpha: 0.12)
        textField.font = .systemFont(ofSize: 17)
        textField.tintColor = UIColor(named: "YPGray")

        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .center
        imageView.tintColor = UIColor(named: "YPGray")

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        imageView.frame = CGRect(x: 8, y: 4, width: 16, height: 16)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always

        return textField
    }()

    private let emptyPlaceholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "empty_placeholder"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        return label
    }()

    private lazy var emptyPlaceholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyPlaceholderImage, emptyPlaceholderLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var filteredCategories: [TrackerCategory] = []

    private var selectedDate = Date()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)

        filterTrackers(for: selectedDate)
        
        collectionView.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier
        )
    }

    // MARK: - Private methods

    private func setupNavigationBar() {
        navigationButtonContainerView.addSubview(addTrackerButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationButtonContainerView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(emptyPlaceholderStack)
        view.addSubview(collectionView)

        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            addTrackerButton.leadingAnchor.constraint(equalTo: navigationButtonContainerView.leadingAnchor, constant: -10),
            addTrackerButton.centerYAnchor.constraint(equalTo: navigationButtonContainerView.centerYAnchor),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),

            navigationButtonContainerView.widthAnchor.constraint(equalToConstant: 60),
            navigationButtonContainerView.heightAnchor.constraint(equalToConstant: 44),

            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyPlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPlaceholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekdayEnum = WeekDay.allCases[(weekday + 5) % 7]
        let weekdaySymbol = weekdayEnum.rawValue

        filteredCategories = categories.map { category in
            let trackers = category.trackers.filter { $0.schedule.contains(weekdaySymbol) }
            return TrackerCategory(title: category.title, trackers: trackers)
        }.filter { !$0.trackers.isEmpty }

        collectionView.reloadData()
        emptyPlaceholderStack.isHidden = !filteredCategories.isEmpty
    }

    // MARK: - Actions

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        filterTrackers(for: selectedDate)
    }

    @objc private func addTrackerButtonTapped() {
        let vc = NewHabitViewController()
        vc.modalPresentationStyle = .automatic
        vc.onCreateTracker = { [weak self] tracker in
            guard let self else { return }

            if let index = self.categories.firstIndex(where: { $0.title == "Привычки" }) {
                let existing = self.categories[index]
                let updatedCategory = TrackerCategory(
                    title: existing.title,
                    trackers: existing.trackers + [tracker]
                )
                self.categories[index] = updatedCategory
            } else {
                self.categories.append(TrackerCategory(title: "Привычки", trackers: [tracker]))
            }

            self.filterTrackers(for: self.selectedDate)
        }
        present(vc, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }

        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]

        let isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }

        let completedCount = completedTrackers.filter {
            $0.trackerId == tracker.id
        }.count

        cell.configure(with: tracker, isCompleted: isCompleted, count: completedCount)

        cell.onToggle = { [weak self] in
            guard let self else { return }

            let calendar = Calendar.current
            if calendar.compare(self.selectedDate, to: Date(), toGranularity: .day) == .orderedDescending {
                return 
            }

            if isCompleted {
                self.completedTrackers.removeAll {
                    $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: self.selectedDate)
                }
            } else {
                self.completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: self.selectedDate))
            }

            collectionView.reloadItems(at: [indexPath])
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 8) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath
        ) -> UICollectionReusableView {
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
                    for: indexPath
                  ) as? TrackerSectionHeader else {
                return UICollectionReusableView()
            }

            let category = filteredCategories[indexPath.section]
            header.configure(with: category.title)
            return header
        }

        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            referenceSizeForHeaderInSection section: Int
        ) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 32)
        }
}
