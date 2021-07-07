//
//  Wordcards+CoreDataProperties.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 6/18/21.
//
//

import Foundation
import CoreData


extension Wordcards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wordcards> {
        return NSFetchRequest<Wordcards>(entityName: "Wordcards")
    }

    @NSManaged public var hint: String?
    @NSManaged public var explanation: String?
    @NSManaged public var word: String?
    @NSManaged public var userID: String?
}

extension Wordcards : Identifiable {

}
