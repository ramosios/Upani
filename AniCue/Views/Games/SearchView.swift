//
//  SearchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 05/11/25.
//
import SwiftUI

struct SearchView: View {
    @ObservedObject var animeList = AnimeListManager.shared
    @State private var searchText: String = ""
    @State private var filteredAnimes: [JikanAnime] = []

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search for anime...", text: $searchText, onCommit: {
                    filterAnimes()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Search Results
                if filteredAnimes.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(filteredAnimes, id: \.malId) { anime in
                        NavigationLink(destination: AnimeDetailView(anime: anime)) {
                            AnimeRowView(
                                anime: anime,
                                isWatchlisted: animeList.isAnimeInList(anime, listType: .watchlist),
                                isWatched: animeList.isAnimeInList(anime, listType: .watched),
                                onToggleWatchlisted: {
                                    withAnimation {
                                        if animeList.isAnimeInList(anime, listType: .watchlist) {
                                            animeList.removeAnime(anime)
                                        } else {
                                            animeList.addOrUpdateAnime(anime, listType: .watchlist)
                                        }
                                    }
                                },
                                onMarkWatched: {
                                    withAnimation {
                                        if animeList.isAnimeInList(anime, listType: .watched) {
                                            animeList.removeAnime(anime)
                                        } else {
                                            animeList.addOrUpdateAnime(anime, listType: .watched)
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Search Anime")
        }
    }
    private func filterAnimes() {
        if searchText.isEmpty {
            filteredAnimes = []
            return
        }
        filteredAnimes = animeList.getAnimes(for: .downloaded).filter { anime in
            anime.title.localizedCaseInsensitiveContains(searchText)
        }
    }
}
