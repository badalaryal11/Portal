//
//  PortalApp.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//


import SwiftUI

@main
struct PortalApp: App {
    // 1. Place the line here, at the top level of your App struct.
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Use the controller here to inject the context into the environment.
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
