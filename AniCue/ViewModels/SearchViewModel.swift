//
//  SearchViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 19/11/25.
//
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredAnimes: [Anime] = []

    private var animeList = AnimeListManager.shared
    private var debounceTask: Task<Void, Never>?

    func debouncedFilter() {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 250_000_000) // 250ms delay
            // Only filter if the task wasn't cancelled
            await MainActor.run {
                self.filterAnimes()
            }
        }
    }
    func filterAnimes() {
        if searchText.isEmpty {
            filteredAnimes = []
            return
        }
        filteredAnimes = animeList.getSearchedAnime(searchText: searchText, numberOfResults: 50)
    }
}
