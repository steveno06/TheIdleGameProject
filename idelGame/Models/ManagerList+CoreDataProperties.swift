//
//  ManagerList+CoreDataProperties.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 2/2/24.
//
//

import Foundation
import CoreData


extension ManagerList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagerList> {
        return NSFetchRequest<ManagerList>(entityName: "ManagerList")
    }

    @NSManaged public var firstFishHasManager: Bool

}

extension ManagerList : Identifiable {

}
