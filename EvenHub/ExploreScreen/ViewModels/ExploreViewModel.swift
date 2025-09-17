//
//  ExploreViewModel.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 17.09.2025.
//

import UIKit

final class ExploreViewModel {
    static let shared = ExploreViewModel()
    
    //MARK: - Properties
    var locationsIsLoaded: (([String]) -> Void)?
    private(set)var category = CategoryType.allCases
    private(set)var locationPlaces = [String]() {
        didSet {
            locationsIsLoaded?(locationPlaces)
        }
    }
    //MARK: - Lifecycle
    private init(){
        fetchLocations()
    }
  
    //MARK: - Private methods
    private func fetchLocations() {
        DispatchQueue.main.async {
            self.locationPlaces = ["First location", "Second location", "Third location", "Fourth location", "Fifth location", "Sixth location"]
        }
    }
}

enum CategoryType: CaseIterable {
    case sport
    case food
    case music
    case art
}

