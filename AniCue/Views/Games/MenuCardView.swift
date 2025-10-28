//
//  MenuCardView.swift
//  AniCue
//
//  Created by Jorge Ramos on 21/10/25.
//
import SwiftUI

struct MenuCardView: View {
    let menuItem: MenuItem
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.teal.opacity(0.8), .teal.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .teal.opacity(0.4), radius: 10, x: 0, y: 8)
            VStack {
                Image(menuItem.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 180)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                Text(menuItem.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .padding()
        }
        .frame(height: 250)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
