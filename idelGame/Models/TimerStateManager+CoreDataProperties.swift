//
//  TimerStateManager+CoreDataProperties.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 31/1/24.
//
//

import Foundation
import CoreData


extension TimerStateManager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimerStateManager> {
        return NSFetchRequest<TimerStateManager>(entityName: "TimerStateManager")
    }

    @NSManaged public var timeOfLogOff: Date?

}

extension TimerStateManager : Identifiable {

}
