import SwiftUI

enum GameListSource {
    case selectGame
}

struct GamesView: View {
    let source: GameListSource
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var animate = false

    var title: String {
        switch source {
        case .selectGame:
            return "Select a Game"
        }
    }
    var games: [Game] {
        switch source {
        case .selectGame:
            return Constants.games
        }
    }

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
            .navigationTitle(title)
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
