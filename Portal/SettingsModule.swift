import SwiftUI

// MARK: - Protocols
protocol ViewToPresenterSettingsProtocol {
    func viewDidLoad()
    func didTapLogout()
    func didTapProfile()
    func didTapNotifications()
    func didTapSecurity()
    func didTapHelp()
    func didTapGiveFeedback()
}

protocol PresenterToRouterSettingsProtocol {
    func performLogout()
}


// MARK: - View
struct SettingsView: View {
    @ObservedObject var presenter: SettingsPresenter

    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Settings", trailingItem: {
                EmptyView() // No trailing items in this header
            }, leadingItem: {
                // Provides a back button to dismiss the sheet
                AnyView(Button(action: onBack) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(Theme.text)
                })
            })

            VStack(spacing: 12) {
                SettingsListItem(icon: Image(systemName: "person.fill"), label: "Profile", onClick: {
                    presenter.didTapProfile()
                })
                SettingsListItem(icon: Image(systemName: "bell.fill"), label: "Notifications", onClick: {
                    presenter.didTapNotifications()
                })
                SettingsListItem(icon: Image(systemName: "shield.fill"), label: "Security", onClick: {
                    presenter.didTapSecurity()
                })
                SettingsListItem(icon: Image(systemName: "questionmark.circle.fill"), label: "Help & Support", onClick: {
                    presenter.didTapHelp()
                })
                SettingsListItem(icon: Image(systemName: "star.bubble.fill"), label: "Give Feedback", onClick: {
                    presenter.didTapGiveFeedback()
                })
                
                Spacer()
                
                Button(action: {
                    presenter.didTapLogout()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.card)
                    .foregroundColor(.red)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - Presenter
class SettingsPresenter: ObservableObject, ViewToPresenterSettingsProtocol {
    var router: PresenterToRouterSettingsProtocol?
    
    // In a real app, you might have an interactor for business logic.
    // var interactor: PresenterToInteractorSettingsProtocol?

    func viewDidLoad() {
        // Fetch any initial settings data if needed
    }

    func didTapProfile() {
        // Use router to navigate to profile screen
        print("Profile tapped")
    }

    func didTapNotifications() {
        // Use router to navigate to notifications screen
        print("Notifications tapped")
    }

    func didTapSecurity() {
        // Use router to navigate to security screen
        print("Security tapped")
    }

    func didTapHelp() {
        // Use router to navigate to help screen
        print("Help tapped")
    }
    
    func didTapGiveFeedback() {
        // Use router to navigate to feedback screen
        print("Give Feedback tapped")
    }

    func didTapLogout() {
        // Ask the router to perform the logout action
        router?.performLogout()
    }
}

// MARK: - Router
class SettingsRouter: PresenterToRouterSettingsProtocol {
    private let onLogout: () -> Void

    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }

    func performLogout() {
        // Execute the closure provided by the parent router
        onLogout()
    }

    static func build(onLogout: @escaping () -> Void, onBack: @escaping () -> Void) -> some View {
        let presenter = SettingsPresenter()
        let router = SettingsRouter(onLogout: onLogout)
        
        presenter.router = router
        
        return SettingsView(presenter: presenter, onBack: onBack)
    }
}

// MARK: - Reusable Settings List Item
struct SettingsListItem: View {
    var icon: Image
    var label: String
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                icon
                    .foregroundColor(Theme.primary)
                    .font(.headline)
                    .frame(width: 24)
                Text(label)
                    .foregroundColor(Theme.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(Theme.card)
            .cornerRadius(12)
        }
    }
}

