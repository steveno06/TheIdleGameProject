//
//  Player+CoreDataProperties.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 25/1/24.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var balance: Double
    @NSManaged public var totalBalanceMade: Double

}

extension Player : Identifiable {

}
