//
//  ChatDataCore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/18/23.
//

import Foundation
import CoreData

struct PersistenceController {
    
    private let container: NSPersistentContainer
    private let containerName: String = "ConversationModel"
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: containerName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        loadPersistentStore()
    }
    private func loadPersistentStore() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error Loading Core Data \(error)")
            }
        }
    }
    
    //main queue context
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    // background context
    var backgroundContext: NSManagedObjectContext {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        return backgroundContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }

        context.perform {
            do {
                try self.context.save()
                print("Context saved successfully.")
            } catch {
                print("Error saving context: \(error)")
                self.context.rollback() // Rollback changes on error
            }
        }
    }
}

