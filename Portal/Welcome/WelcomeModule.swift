//
//  WelcomeModule.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

// --- Protocols ---
protocol WelcomeRouterProtocol {
    func navigateToAuth(mode: String)
}

// --- View ---
struct WelcomeView: View {
    var presenter: WelcomePresenter
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Theme.primary.opacity(0.15), .clear]), center: .top, startRadius: 5, endRadius: 400).ignoresSafeArea()
            VStack {
                Spacer()
                PortalLogo(size: 100).foregroundColor(Theme.primary)
                Text("Portal").font(.system(size: 50, weight: .bold)).foregroundColor(Theme.text)
                Text("Your world, connected. Chat, social, and payments in one place.").font(.headline).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center).padding(.horizontal)
                Spacer()
                VStack(spacing: 16) {
                    Button(action: { presenter.didTapSignUp() }) {
                        Text("Sign Up").font(.headline.bold()).frame(maxWidth: .infinity).padding().background(Theme.primaryBg).foregroundColor(.white).cornerRadius(12)
                    }
                    Button(action: { presenter.didTapLogIn() }) {
                        Text("Log In").font(.headline.bold()).frame(maxWidth: .infinity).padding().background(Theme.card).foregroundColor(.white).cornerRadius(12)
                    }
                }
            }.padding()
        }.background(Theme.bg.ignoresSafeArea())
    }
}

// --- Presenter ---
class WelcomePresenter {
    var router: WelcomeRouterProtocol
    init(router: WelcomeRouterProtocol) { self.router = router }
    func didTapSignUp() { router.navigateToAuth(mode: "signup") }
    func didTapLogIn() { router.navigateToAuth(mode: "login") }
}

// --- Router ---
class WelcomeRouter: WelcomeRouterProtocol {
    private let appRouter: AppRouter
    init(appRouter: AppRouter) { self.appRouter = appRouter }
    func navigateToAuth(mode: String) { appRouter.showAuth(initialMode: mode) }
    
    static func build(router: AppRouter) -> WelcomeView {
        let welcomeRouter = WelcomeRouter(appRouter: router)
        let presenter = WelcomePresenter(router: welcomeRouter)
        return WelcomeView(presenter: presenter)
    }
}

