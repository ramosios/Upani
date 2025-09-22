import SwiftUI

struct CardView: View {
    @Binding var anime: JikanAnime
    @Binding var offset: CGSize

    var onRemove: () -> Void

    @State private var isShowingDetail = false
    @State private var isDragging = false

    var body: some View {
        ZStack {
            // Card Image and Background
            ZStack {
                AsyncImage(url: URL(string: anime.images?.jpg?.largeImageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray5)
                    ProgressView()
                }
                .frame(width: 400, height: 600)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.7), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.25), radius: 12, y: 8)

                // Stronger Gradient Overlay for Text
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(anime.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                            if let type = anime.type, let episodes = anime.episodes {
                                Text("\(type) • \(episodes) episodes")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.85))
                                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.85),
                                .black.opacity(0.5),
                                .clear
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .cornerRadius(16)
                    )
                }
            }
            .frame(width: 400, height: 600)
            .cornerRadius(20)

            // Swipe indicator
            if offset.width > 0 {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(Double(offset.width / 100) - 0.2))
                Text("LIKE")
                    .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    .padding(4).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 4))
            } else if offset.width < 0 {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.red.opacity(Double(abs(offset.width) / 100) - 0.2))
                Text("NOPE")
                    .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    .padding(4).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 4))
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    isDragging = true
                }
                .onEnded { gesture in
                    withAnimation(.spring()) {
                        if abs(gesture.translation.width) > 100 {
                            onRemove()
                        } else {
                            offset = .zero
                        }
                    }
                    isDragging = false
                }
        )
        .onTapGesture {
            if !isDragging {
                isShowingDetail = true
            }
        }
        .navigationDestination(isPresented: $isShowingDetail) {
            AnimeDetailView(anime: anime)
        }
    }
}
