//
//  Extension+RawRepresentable.swift
//  OwnGpt
//
//  Created by Bishalw on 7/25/24.
//

import Foundation

extension RawRepresentable where Self: Codable, RawValue == String {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        self.jsonString ?? "{}"
    }
}
