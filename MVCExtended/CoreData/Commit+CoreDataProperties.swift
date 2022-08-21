//
//  Commit+CoreDataProperties.swift
//  CocoaPet
//
//  Created by Sandhil on 31/07/2022.
//
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var message: String?
    @NSManaged public var url: String?

}

extension Commit : Identifiable {

}
