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
}
