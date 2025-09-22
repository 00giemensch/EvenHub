//
//  EventDetailsVC.swift
//  EvenHub
//
//  Created by Ilnur on 09.09.2025.
//

import UIKit

// MARK: - mockData
enum EventImage {
    case local(name: String)
    case remote(url: String)
}

struct Items: Identifiable {
    var id = UUID().uuidString
    let image: EventImage?
    let title: String
    let subtitle: String

}


// MARK: - test version

class EventDetailsVC: UIViewController {
    
    // MARK: - Properties
    
    private var itemsData: [Items] = []
    private var tableViewHeightConstraint: NSLayoutConstraint!
    var event: FavoriteEvent?
    var image: UIImage?
    
    
    // MARK: - Init
    
    init(event: FavoriteEvent? = nil, image: UIImage? = nil) {
        self.event = event
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        $0.addSubview(scrollContentView)
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(UIScrollView())
    
    private lazy var scrollContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubviews(headerImg, eventsLabel, backButton, shareBtn, favBtn, titleLbl, tableView, subtitleLbl, subtitleContentLbl)
        return $0
    }(UIView())
    
    private lazy var headerImg = UIImageView.make(
        contentMode: .scaleAspectFill,
        backgroundColor: .blue40,
        height: 230
    )
    
    private lazy var shareBtn = UIButton.make(
        image: UIImage(named: "eventDetails_share")?.withRenderingMode(.alwaysOriginal),
        backgroundColor: #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1),
        cornerRadius: 12,
        size: CGSize(width: 40, height: 40),
        action: action
    )
    
    private lazy var action = UIAction { [weak self] _ in
        let secondVC = ShareVC()
        secondVC.modalPresentationStyle = .pageSheet
        if let sheet = secondVC.sheetPresentationController {
            sheet.detents = [.custom { _ in 350 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 35
        }
        self?.present(secondVC, animated: true)
    }

    private lazy var backButton = UIButton.make(
        image: UIImage(named: SeeAllModel.Constants.backButtonIcon)?.withTintColor(.white, renderingMode: .alwaysTemplate),
        size: CGSize(width: 22, height: 22),
        tintColor: .label,
        action: UIAction { [weak self] _ in
            self?.backTapped()
        }
    )
    
    private lazy var eventsLabel = UILabel.make(
        text: "Events Details",
        font: .systemFont(ofSize: 24, weight: .medium),
        color: .white,
        lines: 1
    )
    
    private lazy var favBtn = UIButton.make(
        image: UIImage(named: "common_favorite_add")?.withRenderingMode(.alwaysOriginal),
        backgroundColor: #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1),
        cornerRadius: 12,
        size: CGSize(width: 40, height: 40),
        action: favAction
    )
    
    private lazy var favAction = UIAction { [weak self] _ in
        self?.favTapped()
    }

    
    private let titleLbl = UILabel.make(
        text: "International Band Music Concert",
        font: UIFont(name: Constants.Fonts.book, size: 35),
        color: .black,
        lines: 0
    )
    
    private let subtitleLbl = UILabel.make(
        text: "About Event",
        font: UIFont(name: Constants.Fonts.book, size: 18),
        color: .black
    )
    
    private let subtitleContentLbl = UILabel.make(
        text: "Place eggs...",
        font: UIFont(name: Constants.Fonts.light, size: 16),
        color: .black,
        lines: 0,
        lineSpacing: 6
    )
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(EventDetailsCell.self, forCellReuseIdentifier: "EventDetailsCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = 80
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.backgroundColor = .red
        return $0
    }(UITableView())
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        setupConstr()
        configureUI()
//        configureWithEvent() //Missing argument for parameter 'event' in call
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Configure
    
//    func configureWithEvent() {
//            guard let event = event else { return }
//
//            // Настройка заголовка и описания
//            titleLbl.text = event.title
//            subtitleContentLbl.text = event.description ?? event.bodyText ?? "No description available"
//
//            // Формируем данные для таблицы
//            itemsData = createItems(from: event)
//            tableView.reloadData()
//    }
    func configureWithEvent(event: FavoriteEvent) {
            self.event = event
            titleLbl.text = event.title
        subtitleContentLbl.text = stripHTML(from: event.bodyText ?? "")
            // Загрузка изображения
//            if let imageUrl = event.images.first?.image {
//                headerImg.load(urlString: imageUrl)
//            }
        headerImg.image = image
            itemsData = createItems(from: event)
            tableView.reloadData()
        }
    
    private func createItems(from event: FavoriteEvent) -> [Items] {
        var items: [Items] = []
        
        // 1. Дата и время
//        if let date = event {
            let dateString = formatDate(event.startDate)
            let timeString = formatTime(event.startTime) + (event.endTime != nil ? " - \(formatTime(event.endTime))" : "")
            items.append(Items(
                image: .local(name: "eventDetails_date"),
                title: dateString,
                subtitle: timeString
            ))
//        }
        
        // 2. Место проведения
        if let place = event.place {
            let title = place.title ?? "Unknown place"
            let subtitle = place.address.isEmpty ? "" : place.address // Изменено: убрал "Unknown street" т.к. эта подпись к онлайн эвентам выглядит странно
            items.append(Items(
                image: .local(name: "eventDetails_location"),
                title: title,
                subtitle: subtitle
            ))
        } else if let location = event.eventLocation {
            items.append(Items(
                image: .local(name: "eventDetails_location"),
                title: location.name ?? "Unknown location",
                subtitle: "" // Изменено: та же причина что и выше
            ))
        }
        
        // 3. Организатор
//        print("Participants: \(event.participants)")
        if let participants = event.participants?.allObjects as? [ParticipantEntity]{
            print("Available roles: \(participants.map { $0.roleSlug ?? "nil" })")
            if let participant = participants.first, // Берем первого участника
               let agent = participant.agent {
                let title = agent.title ?? "Unknown organizer"
                print("Organizer found: \(title)")
                items.append(Items(
                    image: .local(name: "eventDetails_organizer"),
                    title: title,
                    subtitle: "Organizer"
                ))
            } else {
                print("No agent found for participant")
                items.append(Items(
                    image: .local(name: "eventDetails_organizer"),
                    title: "Unknown organizer",
                    subtitle: "Organizer"
                ))
            }
        } else {
            print("No participants in event")
            items.append(Items(
                image: .local(name: "eventDetails_organizer"),
                title: "Unknown organizer",
                subtitle: "Organizer"
            ))
        }
        
        return items
    }
    
    private func formatDate(_ dateString: String?) -> String {
            guard let dateString = dateString else { return "Unknown date" }
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "d MMMM, yyyy"
                outputFormatter.locale = Locale(identifier: "ru_RU")
                return outputFormatter.string(from: date)
            }
            return dateString
        }
    
    private func formatTime(_ time: String?) -> String {
            guard let time = time else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            if let date = formatter.date(from: time) {
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
            }
            return time
        }
    
    private func stripHTML(from string: String) -> String {
            let htmlTags = try? NSRegularExpression(pattern: "<[^>]+>", options: [])
            let range = NSRange(location: 0, length: string.utf16.count)
            let cleanedString = htmlTags?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
            return cleanedString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func favTapped() {
        print("Favorite tapped") // пока просто для теста
    }
    
    
    private func configureUI() {
        backButton.layer.cornerRadius = 11
        backButton.backgroundColor = .black.withAlphaComponent(0.1)
        eventsLabel.layer.cornerRadius = 4
        eventsLabel.layer.backgroundColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    private func setupConstr() {
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImg.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            headerImg.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            headerImg.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            eventsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            eventsLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 57),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.centerYAnchor.constraint(equalTo: eventsLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 22),
            backButton.heightAnchor.constraint(equalToConstant: 22),
            
            favBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            favBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),

            shareBtn.trailingAnchor.constraint(equalTo: headerImg.trailingAnchor, constant: -13),
            shareBtn.bottomAnchor.constraint(equalTo: headerImg.bottomAnchor, constant: -13),
            
            titleLbl.topAnchor.constraint(equalTo: headerImg.bottomAnchor, constant: 50),
            titleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            titleLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            
            tableView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            subtitleLbl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 21),
            subtitleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            subtitleLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            
            subtitleContentLbl.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 21),
            subtitleContentLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            subtitleContentLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            subtitleContentLbl.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -120),
            
        ])
        
    }
    
    
}

// MARK: - UITableViewDataSource

extension EventDetailsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsCell", for: indexPath) as? EventDetailsCell else {
            return UITableViewCell()
        }
        
        
        let item = itemsData[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsData.count
    }
}

// MARK: - UITableViewDelegate & UIScrollViewDelegate
extension EventDetailsVC: UIScrollViewDelegate {}
extension EventDetailsVC: UITableViewDelegate {}
