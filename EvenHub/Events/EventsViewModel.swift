//
//  EventsViewModel.swift
//  EvenHub
//
//  Created by Никита Грицунов on 22.09.2025.
//
import UIKit

final class EventsViewModel {
    static let shared = EventsViewModel()
    
    //MARK: - Properties
    private let apiService = EventAPIService()
    var eventsIsLoaded: (() -> Void)?
    var pastEventsIsLoaded: (() -> Void)?
    
    private(set)var upcomingEvents = [EventDTO]() {
        didSet {
            eventsIsLoaded?()
        }
    }
    
    private(set) var pastEvents = [EventDTO]() {
        didSet {
            pastEventsIsLoaded?()
        }
    }
    

    //MARK: - Lifecycle
    private init(){}
    
  
    //MARK: - Private methods

    
    func fetchUpcomingEvents() async {
        do {
            let eventsResponse = try await apiService.getUpcomingEvents(getActualSince(), getActualUntile(), .ru, 2)
            upcomingEvents = eventsResponse
            print(eventsResponse)
            
        }
        catch {
            print("ExploreViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    
    func fetchPastEvents() async {
        do {
            let pastEventsResponse = try await apiService.getPastEvents(getActualUntile(), .ru, 2)
        } catch {
            print("EventsViewModel: \(#function)\nОшибка: \(error.localizedDescription)")
        }
    }
    
        func getActualSince() -> String {
            return String(Int(Date().timeIntervalSince1970))
        }
        
        func getActualUntile() -> String {
            let currentDate = Date()
            var untileDate = String()
            if let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: currentDate) {
                untileDate = String(Int(futureDate.timeIntervalSince1970))
            }
            return untileDate
        }
    
}
