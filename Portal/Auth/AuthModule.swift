//
//  AuthModule.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

// --- Protocols ---
protocol AuthRouterProtocol {
    func navigateToMainApp()
}

// --- View ---
struct AuthView: View {
    @StateObject var presenter: AuthPresenter
    
    var body: some View {
        VStack(spacing: 24) {
            Image("PortalLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Theme.primary)
                Text("Portal")
            Text(presenter.mode == "login" ? "Welcome Back" : "Create Account").font(.largeTitle.bold()).foregroundColor(Theme.text)
            
            HStack {
                Button("Log In") { presenter.mode = "login" }.buttonStyle(AuthTabStyle(isSelected: presenter.mode == "login"))
                Button("Sign Up") { presenter.mode = "signup" }.buttonStyle(AuthTabStyle(isSelected: presenter.mode == "signup"))
            }.padding(4).background(Theme.card).cornerRadius(12)
            
            VStack(spacing: 16) {
                if presenter.mode == "signup" {
                    InputField(icon: Image(systemName: "person.fill"), placeholder: "Full Name", text: $presenter.fullName)
                }
                InputField(icon: Image(systemName: "envelope.fill"), placeholder: "Email Address", text: $presenter.email)
                InputField(icon: Image(systemName: "lock.fill"), placeholder: "Password", text: $presenter.password)
            }
            Spacer()
            Button(action: { presenter.didTapAuthButton() }) {
                Text(presenter.mode == "login" ? "Log In" : "Sign Up").font(.headline.bold()).frame(maxWidth: .infinity).padding().background(Theme.primaryBg).foregroundColor(.white).cornerRadius(12)
            }
        }.padding().background(Theme.bg.ignoresSafeArea())
    }
}

// --- Presenter ---
class AuthPresenter: ObservableObject {
    @Published var mode: String
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    var router: AuthRouterProtocol
    init(initialMode: String, router: AuthRouterProtocol) {
        self.mode = initialMode
        self.router = router
    }
    func didTapAuthButton() { router.navigateToMainApp() }
}

// --- Router ---
class AuthRouter: AuthRouterProtocol {
    private let appRouter: AppRouter
    init(appRouter: AppRouter) { self.appRouter = appRouter }
    func navigateToMainApp() { appRouter.showMainApp() }
    
    static func build(initialMode: String, appRouter: AppRouter) -> AuthView {
        let router = AuthRouter(appRouter: appRouter)
        let presenter = AuthPresenter(initialMode: initialMode, router: router)
        return AuthView(presenter: presenter)
    }
}

// --- View Styles ---
struct AuthTabStyle: ButtonStyle {
    var isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(isSelected ? Theme.primaryBg : .clear)
            .foregroundColor(isSelected ? .white : Theme.textSecondary)
            .cornerRadius(8).scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
