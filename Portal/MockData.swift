//
//  MockData.swift
//  Portal
//
//  Created by Badal Aryal on 11/06/2025.
//

import Foundation

// In a real app, this would be replaced by network services and a persistent store.
class MockData {
    static let instance = MockData()
    private init() {}

    let chats: [Chat] = [
        Chat(id: 999, name: "Portal AI", message: "Ask me anything!", time: "Now", unread: 1, avatar: "AI", isBot: true),
        Chat(id: 1, name: "Priya Bhetwal", message: "Sounds good! See you then.", time: "10:42 AM", unread: 2, avatar: "P"),
        Chat(id: 2, name: "Project Group", message: "Don't forget the deadline is Friday.", time: "9:15 AM", unread: 0, avatar: "PG"),
        Chat(id: 3, name: "Bikram Rana", message: "Thanks for sending the payment!", time: "Yesterday", unread: 0, avatar: "B"),
    ]

    var messages: [Int: [Message]] = [
        999: [Message(sender: "them", text: "Hello! How can I help you today?")],
        1: [
            Message(sender: "them", text: "Hey! Are we still on for lunch tomorrow?"),
            Message(sender: "me", text: "Absolutely! How about 1 PM?"),
            Message(sender: "them", text: "Perfect! I need to send you NRS 2000 for the concert tickets."),
        ],
    ]

    let socialPosts: [SocialPost] = [
        SocialPost(id: 1, name: "Barsha Aryal", handle: "@barshaaryal", avatar: "BA", time: "1h ago", text: "Exploring the city! Found this amazing viewpoint.", image: "https://picsum.photos/id/259/1080/1350"),
        SocialPost(id: 2, name: "Badal Aryal", handle: "@badal_aryal", avatar: "BA", time: "5h ago", text: "Just launched my new portfolio website!", image: "https://picsum.photos/id/20/1080/1350"),
        SocialPost(id: 3, name: "Sumina Lamsal", handle: "@sumina_lamsal", avatar: "SL", time: "3h ago", text: "Getting love from my bruno.", image: "https://picsum.photos/id/237/1080/1350"),
        SocialPost(id: 4, name: "Prashamsa Pokhrel", handle: "@prashmsapokhrel", avatar: "PP", time: "4h ago", text: "Getting ready for a new chapter in my life", image: "https://picsum.photos/id/24/1080/1350"),
    ]
    
    let walletBalance: String = "32,175.50"
    
    let transactions: [WalletTransaction] = [
        WalletTransaction(id: 1, type: "sent", description: "Payment to Badal Aryal ", amount: "2000.00", date: "June 9"),
        WalletTransaction(id: 2, type: "received", description: "From Project Group", amount: "6500.00", date: "June 8"),
    ]
    
    
}
