//
//  Extension+Encodable.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation

extension Encodable {
    var jsonData: Data? {
        try? JSONEncoder().encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

