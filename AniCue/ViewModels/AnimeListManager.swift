import Foundation
import RealmSwift
import SwiftUI

class AnimeListManager: ObservableObject {
    static let shared = AnimeListManager()
    private let realm: Realm
    @Published var watchlist: [Anime] = []
    @Published var watched: [Anime] = []

    private init() {
        RealmDatabaseGenerator.generatePreloadedDatabase()
        if let defaultRealmURL = Realm.Configuration.defaultConfiguration.fileURL {
            let isFirstLaunch = !FileManager.default.fileExists(atPath: defaultRealmURL.path)
            if isFirstLaunch {
                if let bundledRealmURL = Bundle.main.url(forResource: "PreloadedAnimes", withExtension: "realm") {
                    do {
                        try FileManager.default.copyItem(at: bundledRealmURL, to: defaultRealmURL)
                    } catch {
                        fatalError("Failed to copy preloaded Realm file: \(error)")
                    }
                }
            }
        } else {
            fatalError("Could not get default Realm file URL.")
        }
        do {
            realm = try Realm()
            refreshLists()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func addOrUpdateAnime(_ anime: Anime, listType: AnimeListType) {
        objectWillChange.send()
        if let existing = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) {
            try? realm.write {
                existing.listType = listType
            }
        } else {
            let realmAnime = RealmAnime(from: anime, listType: listType)
            try? realm.write {
                realm.add(realmAnime)
            }
        }
        updateList(for: listType)
    }

    func removeAnime(_ anime: Anime) {
        objectWillChange.send()
        guard let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) else { return }
        let listToUpdate = object.listType
        try? realm.write {
            realm.delete(object)
        }
        updateList(for: listToUpdate)
    }

    func deleteAll() {
        objectWillChange.send()
        try? realm.write {
            realm.deleteAll()
        }
        refreshLists()
    }

    func getAnimes(for listType: AnimeListType) -> [Anime] {
        let objects = realm.objects(RealmAnime.self).filter("listType == %@", listType.rawValue)
        return objects.map { $0.toAnime() }
    }
    func getSearchedAnime(searchText: String, numberOfResults: Int) -> [Anime] {
        let results = realm.objects(RealmAnime.self)
            .filter("title CONTAINS[c] %@", searchText)
        return results.map { $0.toAnime() }
    }
    func getFilteredAnime(forGenreId genreId: Int? = nil,filterAnswers: [String]? = nil, numberOfResults: Int,filterByPopularity: Bool? = nil) -> [Anime] {
        var results = realm.objects(RealmAnime.self)
            .filter("listType == %@", AnimeListType.none.rawValue)
        // Filter for all genres
        if let genreId = genreId {
            let genreIdString = String(genreId)
            results = results.filter("combinedGenresId CONTAINS %@", genreIdString)
        }
        // Apply user preference filters
        if let filterAnswers = filterAnswers {
            let filters = formatUserPreference(from: filterAnswers)
            if !filters.format.isEmpty {
                results = results.filter("type == %@", filters.format)
            }
            if filters.minimumScore != Constants.minimumFilterScore {
                results = results.filter("score >= %@", filters.minimumScore)
            }
            if !filters.startDate.isEmpty && !filters.endDate.isEmpty {
                results = results.filter("aired.from >= %@ AND aired.from <= %@", filters.startDate, filters.endDate)
            }
        }
        // Filter by eitheri popularity or score
        let sortKey = (filterByPopularity == true) ? "members" : "score"
        let sortedResults = results.sorted(byKeyPath: sortKey, ascending: false)
        return Array(sortedResults.prefix(numberOfResults)).map { $0.toAnime() }
    }
    func isAnimeInList(_ anime: Anime, listType: AnimeListType) -> Bool {
        guard let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) else { return false }
        return object.listType == listType
    }
    private func refreshLists() {
        watchlist = getAnimes(for: .watchlist)
        watched = getAnimes(for: .watched)
    }
    private func updateList(for listType: AnimeListType) {
        switch listType {
        case .watchlist:
            watchlist = getAnimes(for: .watchlist)
        case .watched:
            watched = getAnimes(for: .watched)
        case .none:
            break
        }
    }
}

enum LocalLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case dataLoadingFailed(Error)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "The file '\(filename).json' was not found in the app bundle."
        case .dataLoadingFailed(let error):
            return "Failed to load data from the file: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode the JSON data: \(error.localizedDescription)"
        }
    }
}
