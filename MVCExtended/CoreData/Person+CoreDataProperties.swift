//
//  Person+CoreDataProperties.swift
//  CocoaPet
//
//  Created by Sandhil on 31/07/2022.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var telephone: Int16

}

extension Person : Identifiable {

}
