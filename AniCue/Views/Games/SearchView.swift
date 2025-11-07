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
                VStack(spacing: 16) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for anime...", text: $searchText, onCommit: {
                            filterAnimes()
                        })
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                    // Search Results
                    if filteredAnimes.isEmpty {
                        Spacer()
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No results found")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
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
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
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
