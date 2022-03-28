//
//  TagsEntity+CoreDataProperties.swift
//  
//
//  Created by Vladislav Yanovsky on 23.09.21.
//
//

import Foundation
import CoreData


extension TagsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagsEntity> {
        return NSFetchRequest<TagsEntity>(entityName: "TagsEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var pet: PetEntity?

}
