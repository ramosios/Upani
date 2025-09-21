//
//  RealmDatabaseGenerator.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/08/25.
//
import Foundation
import RealmSwift
import OSLog

class RealmDatabaseGenerator {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.unknown", category: "RealmDatabaseGenerator")

    static func generatePreloadedDatabase() {
        do {
            // Create Realm file in Documents directory
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            logger.error("Failed to get documents directory")
            return
            }
            let realmURL = documentsPath.appendingPathComponent("PreloadedAnimes.realm")

            // Remove existing file if it exists
            if FileManager.default.fileExists(atPath: realmURL.path) {
                try FileManager.default.removeItem(at: realmURL)
            }
            let config = Realm.Configuration(
                       fileURL: realmURL
                   )
            let realm = try Realm(configuration: config)

            // Clear existing data
            try realm.write {
                realm.deleteAll()
            }

            // Load each JSON file and add to Realm
            for filename in DownloadedAnimesFileNames.fileNames {
                guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
                    logger.warning("File not found: \(filename).json")
                    continue
                }
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let decoder = JSONDecoder()
                    // The JSON files are direct arrays of JikanAnime objects.
                    let animes = try decoder.decode([JikanAnime].self, from: data)
                    let realmAnimes = animes.map { RealmAnime(from: $0, listType: .downloaded) }

                    try realm.write {
                        realm.add(realmAnimes, update: .modified)
                    }

                    logger.info("Added \(realmAnimes.count) animes from \(filename).json")
                } catch {
                    logger.error("Failed to process \(filename).json: \(error.localizedDescription)")
                }
            }

            logger.info("✅ Realm database created at: \(realmURL.path)")
            logger.info("Total animes in database: \(realm.objects(RealmAnime.self).count)")

        } catch {
            logger.error("❌ Failed to create Realm database: \(error.localizedDescription)")
        }
    }
}
