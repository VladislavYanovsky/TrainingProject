

import Foundation
import CoreData

protocol PetPersistenceProtocol {
    func add(pets: [PetsResponseData])
    func get() -> [PetEntity]
    func delete(_ entity: String)
    func getViewContext() -> NSManagedObjectContext
}

class CoreDataManager: PetPersistenceProtocol {
    
    func getViewContext() -> NSManagedObjectContext { 
        return persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "TrainingProject")
        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var  fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PetEntity")
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func add(pets: [PetsResponseData]) {
   
        for pet in pets {
            let newPet = PetEntity(context: self.viewContext)
            newPet.id = Int64(pet.id)
            newPet.name = pet.name
            newPet.status = pet.status
            newPet.photoUrls = pet.photoUrls as NSObject?
            
            let newCategory = CategoryEntity(context: self.viewContext)
            newCategory.id = Int64(pet.category?.id ?? 0)
            newCategory.name = pet.category?.name ?? ""
            
            newPet.category = newCategory

            guard let tags = pet.tags else { continue }
            
            let tagsCollectionForCurrentPet = newPet.tags?.mutableCopy() as? NSMutableSet
            
            for i in tags {
                let newTag = TagsEntity(context: viewContext)
                newTag.id = Int64(i.id ?? 0 )
                newTag.name = i.name
                tagsCollectionForCurrentPet?.add(newTag)
            }
            
            if let unwrappedTagsCollectionForCurrentPet = tagsCollectionForCurrentPet {
               newPet.addToTags(unwrappedTagsCollectionForCurrentPet)
            }
            
                do {
                    try viewContext.save()
                } catch let error as NSError {
                    print("Error: \(error), userInfo: \(error.userInfo)")
                }
          }
    }
    
     func delete(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func get() -> [PetEntity] {
        var petsList: [PetEntity]!
        do {
            petsList = try viewContext.fetch(PetEntity.fetchRequest())
        } catch {}
        return petsList
    }
}


