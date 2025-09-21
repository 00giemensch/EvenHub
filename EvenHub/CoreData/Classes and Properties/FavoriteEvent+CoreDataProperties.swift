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

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var bodyText: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var favoritesCount: Int32
    @NSManaged public var startDate: String?
    @NSManaged public var startTime: String?
    @NSManaged public var endTime: String?
    @NSManaged public var cacheKey: String?
    @NSManaged public var isCached: Bool
    @NSManaged public var cachedDate: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var addedDate: Date?
    @NSManaged public var category: String?
    
    // Relationships
    @NSManaged public var place: PlaceEntity?
    @NSManaged public var eventLocation: EventLocationEntity?
    @NSManaged public var participants: NSSet?
    @NSManaged public var images: NSSet?
}

// MARK: Generated accessors for participants
extension FavoriteEvent {
    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: ParticipantEntity)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: ParticipantEntity)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)
}

// MARK: Generated accessors for images
extension FavoriteEvent {
    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImagesEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImagesEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)
}

extension FavoriteEvent : Identifiable {}
