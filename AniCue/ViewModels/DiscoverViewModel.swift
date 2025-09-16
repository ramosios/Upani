//
//  DiscoverViewModel.swift
//  AniCue
//
//  Created by Jorge Ramos on 15/06/25.
//
import Foundation
import SwiftUI

@MainActor
class DiscoverViewModel: ObservableObject {
    @ObservedObject var animeList = AnimeListManager.shared
    @Published var animes: [JikanAnime] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var noRecommendations = false
    @ObservedObject var userPreferences = UserPreferencesViewModel.shared
    private let openAIService: OpenAIServiceProtocol
    init(openAIService: OpenAIServiceProtocol = OpenAIService(),
         jikaService: JikanServiceProtocol = JikanService()) {
        self.openAIService = openAIService
    }
    func getRecommendations(for prompt: String) async {
        isLoading = true
        errorMessage = nil
        animes = []
        noRecommendations = false
        do {
            let genres: [Int]
            do {
                genres = try await openAIService.fetchGenres(from: prompt)
            } catch {
                throw NSError(domain: "Genre Fetch Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch genres: \(error.localizedDescription)"])
            }

            let filteredAnimes = animeList.getTopRatedDownloadedAnime(forGenreId: genres.first ?? 0,filterAnswers: userPreferences.selectedAnswers, numberOfResults: 50)
            do {
                let topAnimes = try await openAIService.recommendTopAnime(from: filteredAnimes, prompt: prompt)
                self.animes = topAnimes
                self.noRecommendations = topAnimes.isEmpty
            } catch {
                throw NSError(domain: "Recommendation Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get recommendations: \(error.localizedDescription)"])
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
