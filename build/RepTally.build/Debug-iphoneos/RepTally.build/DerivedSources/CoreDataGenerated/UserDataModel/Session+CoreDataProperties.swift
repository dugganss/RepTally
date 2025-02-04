//
//  Session+CoreDataProperties.swift
//  
//
//  Created by Samuel Duggan on 04/02/2025.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var sessionID: UUID?
    @NSManaged public var sets: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for sets
extension Session {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: SetData)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: SetData)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension Session : Identifiable {

}
