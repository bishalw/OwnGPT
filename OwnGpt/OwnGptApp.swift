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
            RootView(vm: RootViewModelImpl(userDefaultsStore: core.userDefaultStore))
                .environmentObject(core)
        }
    }
}
