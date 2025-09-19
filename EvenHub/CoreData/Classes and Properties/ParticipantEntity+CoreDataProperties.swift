//
//  ParticipantEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//

import Foundation
import CoreData

extension ParticipantEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParticipantEntity> {
        return NSFetchRequest<ParticipantEntity>(entityName: "ParticipantEntity")
    }

    @NSManaged public var roleSlug: String?
    @NSManaged public var agent: AgentEntity?
    @NSManaged public var event: FavoriteEvent?
}

extension ParticipantEntity : Identifiable {}
