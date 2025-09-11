//
//  OnboardingModel.swift
//  EvenHub
//
//  Created by Евгений Васильев on 11.09.2025.
//
import Foundation

struct OnboardingModel {
    enum Constants {
        static let skipTitle = "Skip"
        static let nextTitle = "Next"
        static let titleLabelText = ["Explore Upcoming and\nNearby Events"," Web Have Modern Events\nCalendar Feature","  To Look Up More Events or\nActivities Nearby By Map"]
        static let detailLabelText = "In publishing and graphic design, Lorem is\na placeholder text commonly"
        static let iphoneImages = ["iPhoneOne","iPhoneTwo", "iPhoneThree"]
        static let blurImage = "mask"
    }
    
    let numberOfPages = 3
    var currentPage = 0
}
