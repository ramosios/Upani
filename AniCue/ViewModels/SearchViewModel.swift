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

    func filterAnimes() {
        if searchText.isEmpty {
            filteredAnimes = []
            return
        }
        filteredAnimes = animeList.getAnimes(for: .downloaded).filter { anime in
            anime.title.localizedCaseInsensitiveContains(searchText)
        }
    }
}
