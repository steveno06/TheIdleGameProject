//
//  Fish+CoreDataProperties.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 26/1/24.
//
//

import Foundation
import CoreData


extension Fish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fish> {
        return NSFetchRequest<Fish>(entityName: "Fish")
    }

    @NSManaged public var fishType: String?
    @NSManaged public var fishLevel: Int64
    @NSManaged public var cost: Double
    @NSManaged public var production: Double
    @NSManaged public var costMultiplier: Double
    @NSManaged public var productionMultiplier: Double

}

extension Fish : Identifiable {

}
