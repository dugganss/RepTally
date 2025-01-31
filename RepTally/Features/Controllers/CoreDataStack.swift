//
//  CoreDataStack.swift
//  RepTally
//
//  Created by Samuel Duggan on 31/01/2025.
//

import CoreData

/*
 This is a singleton class that manages the UserDataModel's CRUD operations
 */
// code adapted from Apple (n.d.) (setting up a core data stack)
class CoreDataStack: ObservableObject{
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UserDataModel")
        
        container.loadPersistentStores{ _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
            
        }
        return container
    }()
    
    private init() {}
    // end of adapted code
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                print("failed to save context \(error.localizedDescription)")
            }
        }
    }
}
