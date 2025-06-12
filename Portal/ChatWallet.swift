//
//  ChatWallet.swift
//  Portal
//
//  Created by Badal Aryal on 12/06/2025.
//

import SwiftUI

// MARK: - Data Models (Assumed to be in your project)




// MARK: - Mock Data Store
let messages: [Int: [Message]] = [
    1: [
        Message(sender: "them", text: "Hey! Are we still on for lunch tomorrow?"),
        Message(sender: "me", text: "Absolutely! How about 1 PM?"),
        Message(sender: "them", text: "Perfect! I need to send you NRS 2000 for the concert tickets."),
    ],
]

let walletBalance: String = "32,175.50"

let transactions: [WalletTransaction] = [
    WalletTransaction(id: 1, type: "sent", description: "Payment to Priya Gurung", amount: "2000.00", date: "June 12, 2025"),
    WalletTransaction(id: 2, type: "received", description: "From Project Group", amount: "6500.00", date: "June 11, 2025"),
    WalletTransaction(id: 3, type: "sent", description: "Coffee Shop", amount: "750.00", date: "June 11, 2025"),
]



    
// MARK: - Reusable Components


struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline.bold()).padding().frame(maxWidth: .infinity).background(Theme.primaryBg).foregroundColor(.white).cornerRadius(12).scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline.bold()).padding().frame(maxWidth: .infinity).background(Theme.card).foregroundColor(.white).cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1)).scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}


// MARK: - Chat Module Views
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

// MARK: - Wallet Module Views
struct WalletView: View {
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "Wallet") {
                    Button(action: {}) { Image(systemName: "ellipsis").foregroundColor(Theme.textSecondary).font(.title2) }
                }
                ScrollView {
                    VStack(spacing: 24) {
                        // Balance Card
                        VStack {
                            Text("Current Balance").foregroundColor(Theme.textSecondary)
                            Text("NRS \(MockData.instance.walletBalance)").font(.largeTitle.bold())
                            VStack(spacing: 12) {
                                Button(action: {}) { HStack { Image(systemName: "camera"); Text("Send (Scan QR)") } }.buttonStyle(PrimaryButtonStyle())
                                HStack(spacing: 12) {
                                    Button(action: {}) { HStack { Image(systemName: "qrcode"); Text("Request") } }.buttonStyle(SecondaryButtonStyle())
                                    Button(action: {}) { HStack { Image(systemName: "arrow.down.to.line"); Text("Load") } }.buttonStyle(SecondaryButtonStyle())
                                }
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(Theme.card)
                        .cornerRadius(16)

                        // Transactions
                        VStack(alignment: .leading) {
                            Text("Recent Transactions").font(.headline)
                            ForEach(MockData.instance.transactions) { tx in
                                TransactionRowView(transaction: tx)
                            }
                        }
                    }
                    .padding()
                }
            }
            .foregroundColor(Theme.text)
            .background(Theme.bg.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct TransactionRowView: View {
    let transaction: WalletTransaction
    var body: some View {
        HStack {
            Image(systemName: transaction.type == "sent" ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundColor(transaction.type == "sent" ? .red : .green)
                .font(.title)
            VStack(alignment: .leading) {
                Text(transaction.description).bold()
                Text(transaction.date).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Text("\(transaction.type == "sent" ? "-" : "+")NRS \(transaction.amount)")
                .bold()
                .foregroundColor(transaction.type == "sent" ? .red : .green)
        }
        .padding()
        .background(Theme.card)
        .cornerRadius(12)
    }
}

// MARK: - Preview Provider
struct PortalModules_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatListView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Chat List")
            
            ConversationView(chat: MockData.instance.chats[1])
                .preferredColorScheme(.dark)
                .previewDisplayName("Conversation")

            WalletView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Wallet")
        }
    }
}
