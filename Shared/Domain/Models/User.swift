//
//  AuthUser.swift
//  OwnGpt
//
//  Created by Bishalw on 7/2/24.
//

import Foundation

struct User: AuthUser {
    let id: String
    let name: String?
    let email: String?
}
