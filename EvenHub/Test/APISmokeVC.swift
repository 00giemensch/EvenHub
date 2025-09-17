//
//  APISmokeVC.swift
//  EvenHub
//
//  Created by Иван Семенов on 17.09.2025.
//

#if DEBUG
import UIKit

final class APISmokeVC: UIViewController {
    
    private let service = EventAPIService()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            do {
                let locations = try await service.getLocations(with: .ru)
                print("locations:", locations.count)

                let categories = try await service.getCategories(with: .ru)
                print("categories:", categories.count)

                let events = try await service.getUpcomingEvents(with: nil, .ru, 1)
                print("events:", events.count)
            } catch {
                print("error:", error)
            }
        }
        
    }
}
#endif
