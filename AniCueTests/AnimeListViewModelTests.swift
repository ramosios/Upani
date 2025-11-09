//
//  AnimeListViewModelTests.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/06/25.
//
import XCTest
@testable import AniCue

final class AnimeListViewModelTests: XCTestCase {
    var tempFilename: String!
    var viewModel: AnimeListViewModel!

    override func setUp() {
        super.setUp()
        tempFilename = "test_anime_list.json"
        removeTestFile()
        viewModel = AnimeListViewModel(filename: tempFilename)
    }

    override func tearDown() {
        removeTestFile()
        super.tearDown()
    }

    private func removeTestFile() {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(tempFilename),
           FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    private func dummyAnime(id: Int = 1, title: String = "Test") -> Anime {
        return Anime(
            malId: id,
            title: title,
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
    }

    func testAddAnime() {
        let anime = dummyAnime()
        viewModel.add(anime)
        XCTAssertTrue(viewModel.animes.contains(where: { $0.malId == anime.malId }))
    }

    func testAddDuplicateAnimeDoesNotRepeat() {
        let anime = dummyAnime()
        viewModel.add(anime)
        viewModel.add(anime)
        XCTAssertEqual(viewModel.animes.filter { $0.malId == anime.malId }.count, 1)
    }

    func testRemoveAnime() {
        let anime = dummyAnime()
        viewModel.add(anime)
        viewModel.remove(anime)
        XCTAssertFalse(viewModel.animes.contains(where: { $0.malId == anime.malId }))
    }

    func testIsAdded() {
        let anime = dummyAnime()
        viewModel.add(anime)
        XCTAssertTrue(viewModel.isAdded(anime))
    }

    func testClearAll() {
        viewModel.add(dummyAnime(id: 1))
        viewModel.add(dummyAnime(id: 2))
        viewModel.clearAll()
        XCTAssertTrue(viewModel.animes.isEmpty)
    }

    func testPersistence() {
        let anime = dummyAnime(id: 999, title: "Persistent")
        viewModel.add(anime)

        // simulate reload
        let reloaded = AnimeListViewModel(filename: tempFilename)
        XCTAssertTrue(reloaded.animes.contains(where: { $0.malId == anime.malId && $0.title == "Persistent" }))
    }
}

