//
//  MatchViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 12/08/25.
//
import SwiftUI

class MatchViewModel: ObservableObject {
    let source: GameSource
    @ObservedObject var animeList = AnimeListManager.shared
    @Published var animes: [JikanAnime] = []
    @Published var cardOffsets: [Int: CGSize] = [:]
    @Published var errorMessage: String?

    enum SwipeDirection {
        case left, right
    }

    init(source: GameSource) {
        self.source = source
        switch source {
        case .popular:
            animes = animeList.getTopRatedDownloadedAnime(numberOfResults: Constants.resultsMatch)
        case .shounen:
            animes = animeList.getTopRatedDownloadedAnime(forGenreId: Constants.genreDictionary["Shounen"], numberOfResults: Constants.resultsMatch)
        case .shoujo:
            animes = animeList.getTopRatedDownloadedAnime(forGenreId: Constants.genreDictionary["Shoujo"], numberOfResults: Constants.resultsMatch)
        case .romance:
            animes = animeList.getTopRatedDownloadedAnime(forGenreId: Constants.genreDictionary["Romance"], numberOfResults: Constants.resultsMatch)
        }
    }

    private func removeCard(at index: Int) {
        guard index >= 0 && index < animes.count else { return }
        let animeId = animes[index].id
        animes.remove(at: index)
        cardOffsets.removeValue(forKey: animeId)
    }

    func swipeCard(for anime: JikanAnime) {
        guard let index = animes.firstIndex(where: { $0.id == anime.id }) else { return }
        let direction: SwipeDirection = (cardOffsets[anime.id]?.width ?? 0) > 0 ? .right : .left
        withAnimation(.spring()) {
            switch direction {
            case .left:
                cardOffsets[anime.id] = CGSize(width: -500, height: 0)
            case .right:
                cardOffsets[anime.id] = CGSize(width: 500, height: 0)
                animeList.addOrUpdateAnime(anime, listType: .watchlist)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeCard(at: index)
        }
    }
}
