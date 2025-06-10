//
//  MainAppModule.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

// --- Router ---
class MainAppRouter {
    private let appRouter: AppRouter
    init(appRouter: AppRouter) { self.appRouter = appRouter }
    
    func showMainApp(onLogout: @escaping () -> Void) -> AnyView {
        return AnyView(MainAppView(onLogout: onLogout))
    }
    
    static func build(appRouter: AppRouter) -> AnyView {
        let router = MainAppRouter(appRouter: appRouter)
        return router.showMainApp {
            appRouter.showWelcome()
        }
    }
}

// --- View ---
struct MainAppView: View {
    @State private var selectedTab: Tab = .social
    var onLogout: () -> Void
    
    enum Tab: String { case social, chat, wallet }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .social: SocialFeedRouter.build()
                case .chat: ChatListRouter.build()
                case .wallet: WalletRouter.build()
                }
            }
            
            HStack(spacing: 20) {
                TabBarButton(icon: "person.3.fill", label: "Social", isSelected: selectedTab == .social) { selectedTab = .social }
                TabBarButton(icon: "message.fill", label: "Chat", isSelected: selectedTab == .chat) { selectedTab = .chat }
                TabBarButton(icon: "wallet.pass.fill", label: "Wallet", isSelected: selectedTab == .wallet) { selectedTab = .wallet }
            }.padding().background(Theme.card).cornerRadius(25).padding(.horizontal).shadow(radius: 10)
        }.background(Theme.bg.ignoresSafeArea())
    }
}

struct TabBarButton: View {
    var icon: String
    var label: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title2)
                Text(label).font(.caption)
            }.foregroundColor(isSelected ? Theme.primary : Theme.textSecondary).frame(maxWidth: .infinity)
        }
    }
}
