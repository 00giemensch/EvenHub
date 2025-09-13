//
//  EventDetailsVC.swift
//  EvenHub
//
//  Created by Ilnur on 09.09.2025.
//

import UIKit

enum EventImage {
    case local(name: String)
    case remote(url: String)
}

struct Items: Identifiable {
    var id = UUID().uuidString
    let image: EventImage
    let title: String
    let subtitle: String
    
    
    
    static func mockData() -> [Items] {
        return [
            Items(image: .local(name: "eventDetails_date"), title: "14 December, 2021", subtitle: "Tuesday, 4:00PM - 9:00PM"),
            Items(image: .local(name: "eventDetails_location"), title: "Gala Convention Center", subtitle: "36 Guild Street London, UK "),
            Items(image: .local(name: ""), title: "Ashfak Sayem", subtitle: "Organizer")
        ]
    }
}

class EventDetailsVC: UIViewController {
    
    // MARK: - Properties
    
    let itemsData = Items.mockData()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
//    init(items: [itemsData]) {
//        self.items = items
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - UI Elements
    
    lazy var scrollView: UIScrollView = {
        $0.addSubview(scrollContentView)
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(UIScrollView())
    
    lazy var scrollContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(headerImg)
        $0.addSubview(shareBtn)
        $0.addSubview(favBtn)
        $0.addSubview(titleLbl)
        $0.addSubview(tableView)
        $0.addSubview(subtitleLbl)
        $0.addSubview(subtitleContentLbl)
        return $0
    }(UIView())
    
    lazy var headerImg: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 244).isActive = true
        $0.backgroundColor = .orange
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var shareBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1)
        $0.setImage(UIImage(named: "eventDetails_share"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIButton())
    
    lazy var favBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1)
        $0.setImage(UIImage(named: "common_favorite_add"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIButton())
    
    let titleLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "International Band Music Concert"
        $0.font = .systemFont(ofSize: 35, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let subtitleLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "About Event"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let subtitleContentLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Place eggs in a saucepan and cover with cold water. Bring water to a boil and immediately remove from heat. Cover and let eggs stand in hot water for 10 to 12 minutes. Remove from hot water, cool, peel, and chop.Place chopped eggs in a bowl.Add chopped tomatoes, corns, lettuce, and any other vegitable of your choice.Stir in mayonnaise, green onion, and mustard. Season with paprika, salt, and pepper.Stir and serve on your favorite bread or crackers."
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
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
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    func setupConstr() {
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
                
                shareBtn.trailingAnchor.constraint(equalTo: headerImg.trailingAnchor, constant: -13),
                shareBtn.bottomAnchor.constraint(equalTo: headerImg.bottomAnchor, constant: -13),
                
                favBtn.trailingAnchor.constraint(equalTo: headerImg.trailingAnchor, constant: -13),
                favBtn.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 13),
                
                
                titleLbl.topAnchor.constraint(equalTo: headerImg.bottomAnchor, constant: 50),
                titleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
                titleLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),

                tableView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8),
                tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
                tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
                
                subtitleLbl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 21),
                subtitleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),

                subtitleContentLbl.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 21),
                subtitleContentLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
                subtitleContentLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
                subtitleContentLbl.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -50),
                
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
