//
//  ContentView.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject var router = AppRouter()

    var body: some View {
        // The router's view will be displayed here.
        // It updates automatically when the state changes.
        router.currentView
            .onAppear {
                // Set the initial view when the app starts.
                if router.currentView == nil {
                    router.showWelcome()
                }
            }
            .animation(.default, value: router.navigationState)
    }
}

