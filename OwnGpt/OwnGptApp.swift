//
//  OwnGptApp.swift
//  OwnGpt
//


import SwiftUI
import os
import Bkit

@main
struct OwnGptApp: App {
    
    @StateObject var core: Core = Core()
    
    var body: some Scene {
        WindowGroup {
            RootView(vm: RootViewModel(userDefaultsStore: core.userDefaultStore))
                .environmentObject(core)
        }
    }
}
