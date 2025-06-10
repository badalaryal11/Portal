//
//  PortalApp.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

@main
struct PortalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
