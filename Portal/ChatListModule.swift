//
//  ChatListModule.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//
import SwiftUI

// --- View ---
struct ChatListView: View {
    @State private var chats = MockData.instance.chats
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Chats").font(.largeTitle.bold())
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding()
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Theme.textSecondary)
                    TextField("Search chats...", text: $searchText)
                }
                .padding(12)
                .background(Theme.card)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Chat List
                List(chats) { chat in
                    NavigationLink(destination: ConversationView(chat: chat)) {
                        ChatListItemView(chat: chat)
                    }
                    .listRowBackground(Theme.bg)
                    .listRowSeparatorTint(Theme.border)
                }
                .listStyle(.plain)
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .accentColor(Theme.primary)
    }
}

struct ChatListItemView: View {
    let chat: Chat
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                 Text(chat.avatar)
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .background(Theme.primary.opacity(0.5))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                if chat.isBot {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10))
                        .padding(3)
                        .foregroundColor(.white)
                        .background(Theme.primaryBg)
                        .clipShape(Circle())
                }
            }
           
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name).font(.headline).foregroundColor(Theme.text)
                Text(chat.message).font(.subheadline).foregroundColor(Theme.textSecondary).lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.time).font(.caption).foregroundColor(Theme.textSecondary)
                if chat.unread > 0 {
                    Text("\(chat.unread)")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primaryBg)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ConversationView: View {
    let chat: Chat
    @State private var messages: [Message]
    @State private var userInput: String = ""
    @State private var showingCallAlert = false
    
    init(chat: Chat) {
        self.chat = chat
        _messages = State(initialValue: MockData.instance.messages[chat.id] ?? [])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(chat.avatar).font(.title).frame(width: 40, height: 40).background(Theme.primary.opacity(0.5)).clipShape(Circle())
                Text(chat.name).font(.headline)
                Spacer()
                if !chat.isBot {
                    Button(action: { showingCallAlert = true }) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                    }
                }
            }
            .foregroundColor(Theme.text)
            .padding()
            .background(Theme.card)
            .alert(isPresented: $showingCallAlert) {
                Alert(title: Text("Start Call?"), message: Text("Do you want to start a call with \(chat.name)?"), primaryButton: .destructive(Text("Call")) {}, secondaryButton: .cancel())
            }
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ForEach(messages) { message in
                            MessageBubbleView(message: message).id(message.id)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            
            // Input field
            HStack {
                TextField("Type a message...", text: $userInput)
                    .padding(12)
                    .background(Theme.card)
                    .cornerRadius(25)
                
                Button(action: handleSendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Theme.primaryBg)
                }
            }
            .padding()
            .background(Theme.bg)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true) // Hiding default nav bar for custom one
    }

    func handleSendMessage() {
        guard !userInput.isEmpty else { return }
        messages.append(Message(sender: "me", text: userInput))
        userInput = ""
    }
}

struct MessageBubbleView: View {
    let message: Message
    var body: some View {
        HStack {
            if message.sender == "me" { Spacer() }
            Text(message.text)
                .padding()
                .background(message.sender == "me" ? Theme.primaryBg : Theme.card)
                .foregroundColor(.white)
                .cornerRadius(16)
            if message.sender != "me" { Spacer() }
        }
    }
}

// --- Router ---
struct ChatListRouter {
    static func build() -> some View {
        ChatListView()
    }
}
