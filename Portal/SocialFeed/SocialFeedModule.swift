//
//  SocialFeedModule.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

// --- Protocols ---
protocol ViewToPresenterSocialFeedProtocol {
    func viewDidLoad()
    func didTapSettings()
    func didTapCreatePost()
}

protocol PresenterToViewSocialFeedProtocol: AnyObject {
    func displayPosts(_ posts: [SocialPost])
}

protocol PresenterToInteractorSocialFeedProtocol {
    func fetchPosts()
}

protocol InteractorToPresenterSocialFeedProtocol: AnyObject {
    func didFetchPosts(_ posts: [SocialPost])
}

protocol PresenterToRouterSocialFeedProtocol {
    func navigateToSettings()
    func navigateToCreatePost()
}

// --- View ---
struct SocialFeedView: View {
    @StateObject var presenter: SocialFeedPresenter

    var body: some View {
        VStack {
            HeaderView(title: "Feed", trailingItem: {
                HStack(spacing: 16) {
                    Button(action: {}) { Image(systemName: "magnifyingglass") }
                    Button(action: { presenter.didTapCreatePost() }) { Image(systemName: "plus.circle") }
                    Button(action: { presenter.didTapSettings() }) { Image(systemName: "ellipsis") }
                }.foregroundColor(Theme.textSecondary).font(.title2)
            })
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(presenter.posts) { post in SocialCardView(post: post) }
                }.padding()
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .onAppear { presenter.viewDidLoad() }
        .navigationBarHidden(true)
    }
}

struct SocialCardView: View {
    let post: SocialPost
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(post.avatar).font(.title).frame(width: 44, height: 44).background(Theme.primary.opacity(0.5)).foregroundColor(.white).clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(post.name).bold()
                    Text("\(post.handle) · \(post.time)").font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "ellipsis")
            }
            Text(post.text).lineLimit(nil)
            if let imageName = post.image, let url = URL(string: imageName) {
                 AsyncImage(url: url) { image in image.resizable() } placeholder: { Theme.card }
                .aspectRatio(contentMode: .fill).frame(height: 200).clipped().cornerRadius(12)
            }
            Divider().background(Theme.border)
            HStack(spacing: 20) {
                Button(action: {}) { HStack { Image(systemName: "heart"); Text("1.2k") } }
                Spacer()
                Button(action: {}) { HStack { Image(systemName: "message"); Text("88") } }
                Spacer()
                Button(action: {}) { Image(systemName: "square.and.arrow.up") }
                Spacer()
                Button(action: {}) { HStack { Image(systemName: "dollarsign.circle"); Text("Tip") } }
            }.foregroundColor(Theme.textSecondary).font(.subheadline)
        }.padding().background(Theme.card).cornerRadius(12)
    }
}


// --- Presenter ---
class SocialFeedPresenter: ObservableObject, ViewToPresenterSocialFeedProtocol, InteractorToPresenterSocialFeedProtocol {
    @Published var posts: [SocialPost] = []
    var interactor: PresenterToInteractorSocialFeedProtocol?
    var router: PresenterToRouterSocialFeedProtocol?
    
    func viewDidLoad() { interactor?.fetchPosts() }
    func didTapSettings() { router?.navigateToSettings() }
    func didTapCreatePost() { router?.navigateToCreatePost() }
    func didFetchPosts(_ posts: [SocialPost]) { self.posts = posts }
}

// --- Interactor ---
class SocialFeedInteractor: PresenterToInteractorSocialFeedProtocol {
    weak var presenter: InteractorToPresenterSocialFeedProtocol?
    func fetchPosts() {
        let posts = MockData.instance.socialPosts
        presenter?.didFetchPosts(posts)
    }
}

// --- Router ---
class SocialFeedRouter: PresenterToRouterSocialFeedProtocol {
    func navigateToSettings() { print("Navigate to Settings") }
    func navigateToCreatePost() { print("Navigate to Create Post") }
    
    static func build() -> some View {
        let presenter = SocialFeedPresenter()
        let interactor = SocialFeedInteractor()
        let router = SocialFeedRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return NavigationView {
            SocialFeedView(presenter: presenter)
        }.navigationViewStyle(.stack)
    }
}
