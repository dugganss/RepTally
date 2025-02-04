//
//  SetData+CoreDataProperties.swift
//  
//
//  Created by Samuel Duggan on 04/02/2025.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SetData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetData> {
        return NSFetchRequest<SetData>(entityName: "SetData")
    }

    @NSManaged public var completedReps: Int32
    @NSManaged public var num: Int32
    @NSManaged public var repeats: Int32
    @NSManaged public var reps: Int32
    @NSManaged public var workout: String?
    @NSManaged public var session: Session?

}

extension SetData : Identifiable {

}
