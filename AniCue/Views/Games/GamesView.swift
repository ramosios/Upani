import SwiftUI

struct GamesView: View {
    let games = [
        Game(name: "Popular", imageName: "UpaniBackground_Image3"),
        Game(name: "Romance", imageName: "UpaniBackground_Image3"),
        Game(name: "Shounen", imageName: "UpaniBackground_Image3"),
        Game(name: "Shoujo", imageName: "UpaniBackground_Image3"),
        Game(name: "Seinen", imageName: "UpaniBackground_Image3")
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var animate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(games) { game in
                        NavigationLink(destination: MatchView(source: game.name)) {
                            GameCard(game: game, animate: $animate)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select a Game")
            .onAppear { animate = true }
        }
        .accentColor(.teal)
    }
}

struct GameCard: View {
    let game: Game
    @Binding var animate: Bool

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
                Image(game.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 180)
                    .scaleEffect(animate ? 1.05 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
                Text(game.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .padding()
        }
        .frame(height: 250)
    }
}
