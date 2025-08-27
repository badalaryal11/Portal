//
//  Entities.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import Foundation

// MARK: - Data Models
// These are the plain data objects used throughout the app.

struct Chat: Identifiable {
    let id: Int
    let name: String
    let message: String
    let time: String
    var unread: Int
    let avatar: String
    var isBot: Bool = false
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let sender: String
    let text: String
    var isLoading: Bool = false
}

struct SocialPost: Identifiable {
    let id: Int
    let name: String
    let handle: String
    let avatar: String?
    let time: String
    let text: String
    let image: String?
}

struct WalletTransaction: Identifiable {
    let id: Int
    let type: String
    let description: String
    let amount: String
    let date: String
}
