//
//  Extension+String.swift
//  OwnGpt
//
//  Created by Bishalw on 12/9/23.
//

import Foundation

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
