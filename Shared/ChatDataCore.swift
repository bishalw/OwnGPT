//
//  ChatDataCore.swift
//  OwnGpt
//
//  Created by Bishalw on 8/18/23.
//

import Foundation
import CoreData

class ChatDataCore {
    
    private let container: NSPersistentContainer
    private let containerName: String = "ChatDataContainer"
    private let entityName: String = "ChatData"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        loadPersistentStores()
    }
    private func loadPersistentStores() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error Loading Core Data \(error)")
                
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError("Error saving context: \(error)")
                }
            }
        }
    
}
