import SwiftUI

struct GamesView: View {
    let games = [
        Game(name: "Game 1", imageName: "UpaniBackground_Image3", source: .popular),
        Game(name: "Game 2", imageName: "UpaniBackground_Image3", source: .romance),
        Game(name: "Game 3", imageName: "UpaniBackground_Image3", source: .shounen),
        Game(name: "Game 4", imageName: "UpaniBackground_Image3", source: .shoujo)
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
                        NavigationLink(destination: MatchView(source: game.source)) {
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
                            .onAppear { animate = true }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select a Game")
        }
        .accentColor(.teal)
    }
}
