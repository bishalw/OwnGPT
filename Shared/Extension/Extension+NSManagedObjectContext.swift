//
//  Extension+NSManagedObjectContext.swift
//  OwnGpt
//
//  Created by Bishalw on 12/10/23.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func performFetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            self.perform {
                do {
                    let results = try self.fetch(request)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    func performBatchDelete(_ request: NSBatchDeleteRequest) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.perform {
                do {
                    try self.execute(request)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    func performDelete(_ object: NSManagedObject) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.perform {
                self.delete(object)
                continuation.resume()
            }
        }
    }
    
    func performAsync<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.perform {
                do {
                    let result = try block(self)
                    if self.hasChanges {
                        try self.save()
                    }
                    continuation.resume(returning: result)
                } catch {
                    self.rollback()
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

