import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Image
                if let url = anime.images?.jpg?.largeImageUrl ?? anime.images?.webp?.largeImageUrl,
                   let imageUrl = URL(string: url) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(16)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Title and Synopsis
                VStack(alignment: .leading, spacing: 12) {
                    Text(anime.title)
                        .font(.system(.title2, design: .rounded).bold())
                    if let titleJapanese = anime.titleJapanese {
                        Text(titleJapanese)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    if let synopsis = anime.synopsis {
                        Text(synopsis)
                            .font(.system(.body, design: .rounded))
                    }
                }

                // Stats
                HStack(spacing: 20) {
                    if let score = anime.score {
                        Label(String(format: "%.1f", score), systemImage: "star.fill")
                            .foregroundColor(.accentColor)
                    }
                    if let rank = anime.rank {
                        Text("Rank #\(rank)")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    if let popularity = anime.popularity {
                        Text("Pop. #\(popularity)")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }

                // Info Grid
                VStack(spacing: 10) {
                    DetailRow(label: "Episodes", value: anime.episodes?.description)
                    DetailRow(label: "Status", value: anime.status)
                    DetailRow(label: "Duration", value: anime.duration)
                    DetailRow(label: "Type", value: anime.type)
                    DetailRow(label: "Source", value: anime.source)
                    DetailRow(label: "Aired", value: anime.aired?.string)
                    DetailRow(label: "Studios", value: anime.studios?.map(\.name).joined(separator: ", "))
                }

                // Genres/Themes
                if let genres = anime.genres, !genres.isEmpty {
                    TagSection(title: "Genres", tags: genres.map(\.name))
                }
                if let themes = anime.themes, !themes.isEmpty {
                    TagSection(title: "Themes", tags: themes.map(\.name))
                }

                // Trailer
                if let trailerUrl = anime.trailer?.url, let url = URL(string: trailerUrl) {
                    Link("▶︎ Watch Trailer", destination: url)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.top)
                }

                // Streaming
                if let streaming = anime.streaming, !streaming.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available on")
                            .font(.headline)
                        ForEach(streaming, id: \.url) { platform in
                            if let url = URL(string: platform.url) {
                                Link(platform.name, destination: url)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Anime Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String?

    var body: some View {
        if let value = value, !value.isEmpty {
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                    .font(.system(.body, design: .rounded))
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
            }
        }
    }
}

struct TagSection: View {
    let title: String
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(.subheadline, design: .rounded))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}
