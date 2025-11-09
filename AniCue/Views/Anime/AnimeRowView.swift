import SwiftUI

struct AnimeRowView: View {
    let anime: Anime
    let isWatchlisted: Bool
    let isWatched: Bool
    let onToggleWatchlisted: () -> Void
    let onMarkWatched: () -> Void

    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            animeImage
            animeDetails
            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onAppear {
            if let urlString = anime.images?.jpg?.imageUrl ?? anime.images?.webp?.imageUrl,
               let url = URL(string: urlString) {
                imageLoader.load(from: url)
            }
        }
    }

    private var animeImage: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: 90, height: 130)
        .cornerRadius(12)
        .clipped()
    }

    private var animeDetails: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(anime.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)

            HStack(spacing: 8) {
                if let score = anime.score {
                    Label("\(String(format: "%.1f", score))", systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(.teal)
                }

                if let episodes = anime.episodes {
                    Label("\(episodes)", systemImage: "play.rectangle")
                        .font(.subheadline)
                        .foregroundColor(.teal)
                }
            }

            if let source = anime.source {
                Label(source, systemImage: "sparkles")
                    .font(.subheadline)
                    .foregroundColor(.teal)
            }

            HStack(spacing: 14) {
                Button(action: onToggleWatchlisted) {
                    Image(systemName: isWatchlisted ? "heart.fill" : "heart")
                        .foregroundColor(.teal)
                        .padding(6)
                        .background(Circle().fill(Color.teal.opacity(0.15)))
                }

                Button(action: onMarkWatched) {
                    HStack(spacing: 6) {
                        Image(systemName: isWatched ? "checkmark.circle.fill" : "eye")
                        Text(isWatched ? "Watched" : "Mark Watched")
                    }
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.top, 4)
        }
    }
}
