//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Field Employee on 4/14/20.
//
//

import Foundation
import CoreData
import UIKit


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: Data?

}
