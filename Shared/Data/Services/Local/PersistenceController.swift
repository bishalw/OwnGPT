//
//  ChatDataCore.swift
//  OwnGpt
//
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
                fatalError("Error Loading Core Data \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // Computed property for background context
    var backgroundContext: NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func saveChanges() async {
        guard viewContext.hasChanges else { return }
        
        let context = backgroundContext

        do {
            try await context.performAsync { context in
                try context.save()
                self.mergeChangesFromBackgroundContext(context)
                Log.shared.info("BackgroundContext saved successfully.")
            }
        } catch {
            Log.shared.error("Error saving BackgroundContext: \(error)")
            context.rollback()
        }
    }
    
    private func mergeChangesFromBackgroundContext(_ context: NSManagedObjectContext) {
        viewContext.perform {
            do {
                if self.viewContext.hasChanges {
                    try self.viewContext.save()
                    Log.shared.info("ViewContext merged and saved successfully.")
                }
            } catch {
                Log.shared.info("Error merging changes to ViewContext: \(error)")
                
            }
        }
    }
}
