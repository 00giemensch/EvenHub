//
//  ProfileModel.swift
//  EvenHub
//
//  Created by Евгений Васильев on 12.09.2025.
//
import Foundation

struct ProfileModel {
    enum Constants {
        static let profileTitle = "Profile"
        static let profileImage = "authentication_eventHubImage"
        static let nameLabel = "Ashfak Sayem"
        static let editIconImage = "profile_sign_out"
        static let airBnbCerealBookFont = "AirbnbCereal_Book"
        static let aboutLabel = "About Me"
    }
    
    let numberOfPages = 3
    var currentPage = 0
}
