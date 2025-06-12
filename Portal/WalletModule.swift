//
//  WalletModule.swift
//  Portal
//
//  Created by Badal Aryal on 11/06/2025.
//

import SwiftUI

import SwiftUI

// --- View ---
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


// --- Router ---
struct WalletRouter {
    static func build() -> some View {
        WalletView()
    }
}

// --- Reusable Button Styles ---
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
