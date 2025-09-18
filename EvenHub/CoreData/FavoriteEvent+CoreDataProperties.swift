//
//  FavoriteEvent+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//

import Foundation
import CoreData


extension FavoriteEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEvent> {
        return NSFetchRequest<FavoriteEvent>(entityName: "FavoriteEvent")
    }

    @NSManaged public var bodyText: String?
    @NSManaged public var endTime: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var favoritesCount: Int32
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var locationSlug: String?
    @NSManaged public var longitude: Double
    @NSManaged public var participantsJSON: String?
    @NSManaged public var placeAdress: String?
    @NSManaged public var placeSlug: String?
    @NSManaged public var placeTitle: String?
    @NSManaged public var startDate: String?
    @NSManaged public var startTime: String?
    @NSManaged public var title: String?

}

extension FavoriteEvent : Identifiable {

}
