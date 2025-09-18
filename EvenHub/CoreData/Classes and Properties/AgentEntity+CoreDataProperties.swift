//
//  AgentEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//

import Foundation
import CoreData

extension AgentEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgentEntity> {
        return NSFetchRequest<AgentEntity>(entityName: "AgentEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var participant: ParticipantEntity?
    @NSManaged public var images: NSSet?
}

// MARK: Generated accessors for images
extension AgentEntity {
    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImagesEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImagesEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)
}

extension AgentEntity : Identifiable {}
