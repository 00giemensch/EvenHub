//
//  ImagesEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//
import Foundation
import CoreData

extension ImagesEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagesEntity> {
        return NSFetchRequest<ImagesEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var image: String?
    @NSManaged public var event: FavoriteEvent?
    @NSManaged public var agent: AgentEntity?
}

extension ImagesEntity : Identifiable {}
