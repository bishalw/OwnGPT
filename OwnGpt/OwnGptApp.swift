//
//  OwnGptApp.swift
//  OwnGpt
//


import SwiftUI
import os


@main
struct OwnGptApp: App {
    
    @StateObject var core: Core = Core()
    
    var body: some Scene {
        WindowGroup {
                MainView().environmentObject(core)
                    
        }
    }
}
