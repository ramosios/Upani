//
//  DiscoverViewModelTests.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/06/25.
//
import XCTest
@testable import AniCue

// MARK: - Mock Services

final class MockOpenAIService: OpenAIServiceProtocol {
    var mockTitles: [String] = []
    var shouldFail = false

    func fetchAnimeTitles(prompt: String, userPreferences: [String], excluding moviesToAvoid: [Anime]) async throws -> [String] {
        if shouldFail {
            throw OpenAIError.serverError("Mock OpenAI failure")
        }
        return mockTitles
    }
}

final class MockJikanService: JikanServiceProtocol {
    var mockAnimes: [Anime] = []
    var shouldFail = false

    func fetchAnimes(for titles: [String]) async throws -> [Anime] {
        if shouldFail {
            throw JikanBatchError.serverError(title: "Mock", message: "Mock Jikan failure")
        }
        return mockAnimes
    }
}

// MARK: - ViewModel Tests

@MainActor
final class DiscoverViewModelTests: XCTestCase {
    func testSuccessfulRecommendations() async {
        let mockAI = MockOpenAIService()
        let mockJikan = MockJikanService()

        mockAI.mockTitles = ["Death Note"]
        mockJikan.mockAnimes = [
            Anime(
                malId: 1,
                title: "Death Note",
                titleEnglish: nil,
                titleJapanese: nil,
                titleSynonyms: nil,
                synopsis: nil,
                type: "TV",
                episodes: nil,
                duration: nil,
                status: nil,
                score: nil,
                rank: nil,
                popularity: nil,
                members: nil,
                favorites: nil,
                images: nil,
                trailer: nil,
                aired: nil,
                studios: nil,
                producers: nil,
                licensors: nil,
                genres: nil,
                themes: nil,
                demographics: nil,
                source: nil,
                broadcast: nil,
                streaming: nil
            )
        ]

        let vm = DiscoverViewModel(openAIService: mockAI, jikaService: mockJikan)
        await vm.getRecommendations(for: "dark thrillers", userPreferences: [], avoiding: [])

        XCTAssertEqual(vm.animes.count, 1)
        XCTAssertEqual(vm.animes.first?.title, "Death Note")
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func testOpenAIFailure() async {
        let mockAI = MockOpenAIService()
        mockAI.shouldFail = true

        let vm = DiscoverViewModel(openAIService: mockAI, jikaService: MockJikanService())
        await vm.getRecommendations(for: "any", userPreferences: [], avoiding: [])

        XCTAssertTrue(vm.animes.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func testJikanFailure() async {
        let mockAI = MockOpenAIService()
        mockAI.mockTitles = ["Any"]
        let mockJikan = MockJikanService()
        mockJikan.shouldFail = true

        let vm = DiscoverViewModel(openAIService: mockAI, jikaService: mockJikan)
        await vm.getRecommendations(for: "any", userPreferences: [], avoiding: [])

        XCTAssertTrue(vm.animes.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }
}
