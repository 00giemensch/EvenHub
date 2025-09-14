//
//  ExploreCellDateView.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 13.09.2025.
//

import UIKit

class ExploreCellDateView: UIView {
    //MARK: - UI Components
    private let dayLabel = UILabel()
    private let monthLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white.withAlphaComponent(0.7)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func createDayAttributedString(day: String) -> NSAttributedString {
        let dateStr = NSMutableAttributedString()
        let dayAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.light, size: 26) ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor(resource: .accentRed),
            .kern: 2,
            .expansion: -0.75,
        ]
        dateStr.append(NSAttributedString(string: day, attributes: dayAttributes))
        
        return dateStr
    }
    
    func setDate(day: String, month: String) {
        dayLabel.attributedText = createDayAttributedString(day: day)
        monthLabel.text = month
    }
    func removeText() {
        dayLabel.attributedText = nil
        monthLabel.text = nil
    }
    
    //MARK: - Setup Layout
    private func setupView() {
        setupMonthLabel()
        setupDayLabel()
    }
    private func setupMonthLabel() {
        self.addSubview(monthLabel)
        monthLabel.font = UIFont(name: Constants.Fonts.bold, size: 12)
        monthLabel.adjustsFontSizeToFitWidth = true
        monthLabel.textColor = UIColor(resource: .accentRed)
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            monthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            monthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6)
        ])
    }
    private func setupDayLabel() {
        self.addSubview(dayLabel)
        dayLabel.font = UIFont(name: Constants.Fonts.light, size: 22)
        dayLabel.textColor = UIColor(resource: .accentRed)
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: monthLabel.topAnchor)
        ])
    }
}
