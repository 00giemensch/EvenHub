//
//  CoordinatesEntity+CoreDataProperties.swift
//  EvenHub
//
//  Created by Евгений Васильев on 18.09.2025.
//
//
import Foundation
import CoreData
import CoreLocation

extension CoordinatesEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordinatesEntity> {
        return NSFetchRequest<CoordinatesEntity>(entityName: "CoordinatesEntity")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var place: PlaceEntity?
}

extension CoordinatesEntity : Identifiable {
    public var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
