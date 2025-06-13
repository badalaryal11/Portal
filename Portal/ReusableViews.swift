//
//  ReusableViews.swift
//  Portal
//
//  Created by Badal Aryal on 10/06/2025.
//

import SwiftUI

 // This replaces the old PortalLogo view

struct PortalLogo: View {
    var size: CGFloat = 24
    var body: some View {
        ZStack {
            Circle().stroke(Theme.primary, lineWidth: 1.5)
            Path { path in
                path.move(to: CGPoint(x: size * 0.625, y: size * 0.708))
                path.addLine(to: CGPoint(x: size * 0.625, y: size * 0.292))
                path.addLine(to: CGPoint(x: size * 0.375, y: size * 0.292))
                path.addLine(to: CGPoint(x: size * 0.375, y: size * 0.458))
                path.addCurve(to: CGPoint(x: size * 0.542, y: size * 0.458), control1: CGPoint(x: size * 0.375, y: size * 0.458), control2: CGPoint(x: size * 0.458, y: size * 0.458))
            }.stroke(Theme.primary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        }.frame(width: size, height: size)
    }
}

struct InputField: View {
    var icon: Image
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            icon.foregroundColor(Theme.textSecondary).padding(.leading, 12)
            TextField(placeholder, text: $text).foregroundColor(Theme.text).autocapitalization(.none)
        }
        .frame(height: 50)
        .background(Theme.card.opacity(0.5))
        .cornerRadius(12)
    }
}

struct HeaderView<TrailingContent: View>: View {
    let title: String
    var leadingItem: (() -> AnyView)?
    var trailingItem: () -> TrailingContent
    
    init(title: String, @ViewBuilder trailingItem: @escaping () -> TrailingContent, leadingItem: (() -> AnyView)? = nil) {
        self.title = title
        self.trailingItem = trailingItem
        self.leadingItem = leadingItem
    }
    
    var body: some View {
        HStack {
            if let leadingItem = leadingItem { leadingItem() }
            PortalLogo().foregroundColor(Theme.primary)
            Text(title).font(.largeTitle.bold()).foregroundColor(Theme.text)
            Spacer()
            trailingItem()
        }.padding().background(Theme.card)
    }
}
