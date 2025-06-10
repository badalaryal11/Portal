//
//  AppRouter.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

// The main router controls which high-level view is shown (Welcome, Auth, or Main App).
class AppRouter: ObservableObject {
    @Published var currentView: AnyView?
    @Published var navigationState: String = "welcome" // Used to trigger animations

    func showWelcome() {
        self.navigationState = "welcome"
        self.currentView = AnyView(WelcomeRouter.build(router: self))
    }

    func showAuth(initialMode: String) {
        self.navigationState = "auth"
        self.currentView = AnyView(AuthRouter.build(initialMode: initialMode, appRouter: self))
    }

    func showMainApp() {
        self.navigationState = "loggedIn"
        self.currentView = AnyView(MainAppRouter.build(appRouter: self))
    }
}
