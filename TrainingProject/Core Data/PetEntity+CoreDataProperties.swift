//
//  PetEntity+CoreDataProperties.swift
//  
//
//  Created by Vladislav Yanovsky on 23.09.21.
//
//

import Foundation
import CoreData


extension PetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetEntity> {
        return NSFetchRequest<PetEntity>(entityName: "PetEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var photoUrls: NSObject?
    @NSManaged public var status: String?
    @NSManaged public var category: CategoryEntity?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension PetEntity {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagsEntity)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagsEntity)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
