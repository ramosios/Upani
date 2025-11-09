import SwiftUI

struct AnimeListView: View {
    @ObservedObject var animeList = AnimeListManager.shared
    let animes: [Anime]
    let source: AnimeListSource

    var title: String {
        switch source {
        case .watchlist: return "Watchlist"
        case .watched: return "Watched"
        case .discover: return ""
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(animes, id: \.malId) { anime in
                    let isWatchlisted = animeList.isAnimeInList(anime, listType: .watchlist)
                    let isWatched = animeList.isAnimeInList(anime, listType: .watched)

                    NavigationLink(destination: AnimeDetailView(anime: anime)) {
                        AnimeRowView(
                            anime: anime,
                            isWatchlisted: isWatchlisted,
                            isWatched: isWatched,
                            onToggleWatchlisted: {
                                withAnimation {
                                    if isWatchlisted {
                                        animeList.removeAnime(anime)
                                    } else {
                                        animeList.addOrUpdateAnime(anime, listType: .watchlist)
                                    }
                                }
                            },
                            onMarkWatched: {
                                withAnimation {
                                    if isWatched {
                                        animeList.removeAnime(anime)
                                    } else {
                                        animeList.addOrUpdateAnime(anime, listType: .watched)
                                    }
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}
enum AnimeListSource {
    case watchlist
    case watched
    case discover
}
