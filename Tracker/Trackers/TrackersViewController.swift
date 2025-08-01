//
//  TrackersViewController.swift
//  Tracker
//
//  Класс экрана списка трекеров

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Public Properties
    /// Список всех категорий с трекерами (мок)
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Привычки", trackers: [])
    ]
    
    private lazy var trackerStore: TrackerStore = {
        return TrackerStore(context: TrackerCategoryStore.shared.internalContextForStores)
    }()

    private lazy var trackerRecordStore: TrackerRecordStore = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("❌ Unable to cast UIApplicationDelegate to AppDelegate")
        }
        return TrackerRecordStore(context: appDelegate.persistentContainer.viewContext)
    }()

    
    
    /// Массив завершённых трекеров с датами
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
    /// Дата, выбранная в календаре
    private var selectedDate = Date()
    
    /// Отфильтрованные категории, которые будут отображены в коллекции
    private var filteredCategories: [TrackerCategory] = []
    
    /// Выбор даты — отображается в навигационной панели
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .systemBlue
        return picker
    }()
    
    /// Кнопка добавления нового трекера
    private let addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add_tracker_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    /// Контейнер для кнопки добавления в навигационной панели
    private let navigationButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Заголовок экрана
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    /// Поле поиска трекеров по названию
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.backgroundColor = UIColor(hex: "#767680", alpha: 0.12)
        textField.font = .systemFont(ofSize: 17)
        textField.tintColor = UIColor(resource: .ypGray)
        
        // Иконка лупы слева
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .center
        imageView.tintColor = UIColor(resource: .ypGray)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        imageView.frame = CGRect(x: 8, y: 4, width: 16, height: 16)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    /// Картинка-плейсхолдер, когда нет трекеров
    private let emptyPlaceholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "empty_placeholder"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// Текст-плейсхолдер, когда нет трекеров
    private let emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .ypBlack)
        label.textAlignment = .center
        return label
    }()
    
    /// Стэк из картинки и текста плейсхолдеров
    private lazy var emptyPlaceholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyPlaceholderImage, emptyPlaceholderLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    /// Коллекция, отображающая трекеры по категориям
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        
        completedTrackers = trackerRecordStore.getAllRecords()
        
        // Настройка делегатов и регистрация ячеек
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier
        )
        
        // Фильтрация трекеров по текущей дате
        filterTrackers(for: selectedDate)
    }
    
    // MARK: - Private Methods
    /// Настройка навигационной панели: кнопка + и выбор даты
    private func setupNavigationBar() {
        navigationButtonContainerView.addSubview(addTrackerButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationButtonContainerView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    /// Добавление UI-элементов на экран
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(emptyPlaceholderStack)
        view.addSubview(collectionView)
        
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
    }
    
    /// Установка констрейнтов
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
    
    /// Фильтрация трекеров по дню недели выбранной даты
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekdayEnum = WeekDay.allCases[(weekday + 5) % 7]
        let weekdaySymbol = weekdayEnum.rawValue

        _ = trackerStore.getTrackers()

        guard let allCategories = try? TrackerCategoryStore.shared.fetchCategories() else {
            print("❌ Не удалось получить категории")
            filteredCategories = []
            collectionView.reloadData()
            emptyPlaceholderStack.isHidden = false
            return
        }

        filteredCategories = allCategories.compactMap { category in
            let trackers = category.trackers.filter { $0.schedule.contains(weekdaySymbol) }
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }

        collectionView.reloadData()
        emptyPlaceholderStack.isHidden = !filteredCategories.isEmpty
    }
    
    // MARK: - Actions
    /// Обработка выбора новой даты в DatePicker
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        filterTrackers(for: selectedDate)
    }
    
    /// Обработка нажатия на кнопку добавления трекера
    @objc private func addTrackerButtonTapped() {
        let vc = NewHabitViewController()
        vc.modalPresentationStyle = .automatic

        vc.onCreateTracker = { [weak self] tracker, categoryTitle in
            guard let self = self else { return }

            let store = self.trackerStore

            guard let categoryFromGlobalStore = try? TrackerCategoryStore.shared.fetchCategoryCoreData(with: categoryTitle) else {
                print("❌ Не удалось найти категорию с названием \(categoryTitle)")
                return
            }

            let categoryInTrackerContext = store.exposedContext.object(with: categoryFromGlobalStore.objectID) as? TrackerCategoryCoreData

            guard let finalCategory = categoryInTrackerContext else {
                print("❌ Не удалось перенести категорию в нужный контекст")
                return
            }

            store.addTracker(tracker, to: finalCategory)
            print("✅ Трекер '\(tracker.name)' сохранён в категории '\(categoryTitle)'")

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
        
        // Проверяем, завершён ли трекер в выбранный день
        let isCompleted = completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
        
        // Кол-во завершений трекера
        let completedCount = completedTrackers.filter {
            $0.trackerId == tracker.id
        }.count
        
        cell.configure(with: tracker, isCompleted: isCompleted, count: completedCount)
        
        // Обработка переключения трекера
        cell.onToggle = { [weak self] in
            guard let self else { return }
            
            let calendar = Calendar.current
            if calendar.compare(self.selectedDate, to: Date(), toGranularity: .day) == .orderedDescending {
                return
            }
            
            if isCompleted {
                self.trackerRecordStore.deleteRecord(trackerId: tracker.id, date: self.selectedDate)
                self.completedTrackers.removeAll {
                    $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: self.selectedDate)
                }
            } else {
                let newRecord = TrackerRecord(trackerId: tracker.id, date: self.selectedDate)
                self.trackerRecordStore.addRecord(newRecord)
                self.completedTrackers.append(newRecord)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 32)
    }
}
