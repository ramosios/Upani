//
//  SearchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 05/11/25.
//
import SwiftUI

struct SearchView: View {
    @ObservedObject var animeList = AnimeListManager.shared
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
            NavigationStack {
                VStack(spacing: 16) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for anime...", text: $viewModel.searchText)
                            .foregroundColor(.primary)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: viewModel.searchText) { _, _ in
                                viewModel.debouncedFilter()
                            }
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.primary.opacity(0.08), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                    // Search Results
                    if viewModel.filteredAnimes.isEmpty {
                        Spacer()
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(Color.secondary)
                            Text("No results found")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                        }
                        Spacer()
                    } else {
                        List(viewModel.filteredAnimes, id: \.malId) { anime in
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
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.primary.opacity(0.04), radius: 2, x: 0, y: 1)
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
}
