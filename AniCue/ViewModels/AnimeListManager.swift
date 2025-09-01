import Foundation
import RealmSwift

class AnimeListManager: ObservableObject {
    static let shared = AnimeListManager()
    private let realm: Realm

    @Published var watchlist: [JikanAnime] = []
    @Published var watched: [JikanAnime] = []

    private init() {
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

    func addOrUpdateAnime(_ anime: JikanAnime, listType: AnimeListType) {
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

    func removeAnime(_ anime: JikanAnime) {
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

    func getAnimes(for listType: AnimeListType) -> [JikanAnime] {
        let objects = realm.objects(RealmAnime.self).filter("listType == %@", listType.rawValue)
        return objects.map { $0.toJikanAnime() }
    }

    func isAnimeInList(_ anime: JikanAnime, listType: AnimeListType) -> Bool {
        guard let object = realm.object(ofType: RealmAnime.self, forPrimaryKey: anime.malId) else { return false }
        return object.listType == listType
    }
    func getSampleDownloads() -> [JikanAnime] {
        let downloadedObjects = realm.objects(RealmAnime.self).filter("listType == %@", AnimeListType.downloaded.rawValue)
        var downloadedAnimes: [JikanAnime] = []
        downloadedAnimes.reserveCapacity(100)
        for animeObject in downloadedObjects.prefix(100) {
            downloadedAnimes.append(animeObject.toJikanAnime())
        }
        return downloadedAnimes
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
        case .downloaded:
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
