//
//  EventLocationEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//

import Foundation
import CoreData

extension EventLocationEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventLocationEntity> {
        return NSFetchRequest<EventLocationEntity>(entityName: "EventLocationEntity")
    }

    @NSManaged public var slug: String
    @NSManaged public var name: String?
    @NSManaged public var event: FavoriteEvent?
}

extension EventLocationEntity : Identifiable {}
