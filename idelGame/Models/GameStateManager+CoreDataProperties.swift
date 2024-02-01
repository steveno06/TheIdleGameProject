//
//  GameStateManager+CoreDataProperties.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 1/2/24.
//
//

import Foundation
import CoreData


extension GameStateManager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameStateManager> {
        return NSFetchRequest<GameStateManager>(entityName: "GameStateManager")
    }

    @NSManaged public var firstFishStatus: Int64

}

extension GameStateManager : Identifiable {

}
