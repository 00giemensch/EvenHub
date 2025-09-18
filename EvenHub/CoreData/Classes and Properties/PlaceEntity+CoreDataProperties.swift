//
//  PlaceEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//
import Foundation
import CoreData

extension PlaceEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceEntity> {
        return NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var slug: String
    @NSManaged public var address: String
    @NSManaged public var location: String
    @NSManaged public var coordinates: CoordinatesEntity?
    @NSManaged public var event: FavoriteEvent?
}

extension PlaceEntity : Identifiable {}
