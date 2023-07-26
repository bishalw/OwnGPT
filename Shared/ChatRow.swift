//
//  ChatRow.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct ChatRow: Identifiable, Hashable {
    
    let id = UUID()
    var isInteractingWithOwnGPT: Bool
    
    let UserIcon: String
    let sendText: String
    
    let responseGPTIcon: String
    var responseText: String?
    var responseError: String?
    
}
