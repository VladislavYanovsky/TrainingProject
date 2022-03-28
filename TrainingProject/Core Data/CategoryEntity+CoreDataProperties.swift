//
//  CategoryEntity+CoreDataProperties.swift
//  
//
//  Created by Vladislav Yanovsky on 23.09.21.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var pet: PetEntity?

}
