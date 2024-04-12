//
//  Note+CoreDataProperties.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 5.04.24.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var time: Date?
    @NSManaged public var drawing: Data?

}

extension Note : Identifiable {

}
