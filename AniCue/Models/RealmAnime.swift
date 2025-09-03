//
//  RealmAnime.swift
//  AniCue
//
//  Created by Jorge Ramos on 08/07/25.
//
import Foundation
import RealmSwift

// MARK: - List Type Enum
enum AnimeListType: String, PersistableEnum {
    case watched
    case watchlist
    case downloaded
}

// MARK: - Main Anime Model
class RealmAnime: Object {
    @Persisted(primaryKey: true) var malId: Int
    @Persisted var title: String
    @Persisted var titleEnglish: String?
    @Persisted var titleJapanese: String?
    @Persisted var synopsis: String?
    @Persisted var type: String?
    @Persisted var episodes: Int?
    @Persisted var duration: String?
    @Persisted var status: String?
    @Persisted var score: Double?
    @Persisted var rank: Int?
    @Persisted var popularity: Int?
    @Persisted var members: Int?
    @Persisted var favorites: Int?
    @Persisted var source: String?
    // Relationships
    @Persisted var images: RealmImageFormats?
    @Persisted var trailer: RealmTrailer?
    @Persisted var aired: RealmAiredPeriod?
    @Persisted var broadcast: RealmBroadcast?
    @Persisted var studios = List<RealmEntity>()
    @Persisted var producers = List<RealmEntity>()
    @Persisted var licensors = List<RealmEntity>()
    @Persisted var genres = List<RealmEntity>()
    @Persisted var themes = List<RealmEntity>()
    @Persisted var demographics = List<RealmEntity>()
    @Persisted var streaming = List<RealmStreaming>()
    @Persisted var titleSynonyms = List<String>()
    // Add enum property for list type
    @Persisted var listType: AnimeListType
    // Conversion methods
    convenience init(from anime: JikanAnime, listType: AnimeListType) {
        self.init()
        self.malId = anime.malId
        self.listType = listType
        self.title = anime.title
        self.titleEnglish = anime.titleEnglish
        self.titleJapanese = anime.titleJapanese
        self.synopsis = anime.synopsis
        self.type = anime.type
        self.episodes = anime.episodes
        self.duration = anime.duration
        self.status = anime.status
        self.score = anime.score
        self.rank = anime.rank
        self.popularity = anime.popularity
        self.members = anime.members
        self.favorites = anime.favorites
        self.source = anime.source
        // Copy title synonyms
        if let synonyms = anime.titleSynonyms {
            synonyms.forEach { self.titleSynonyms.append($0) }
        }
        // Create complex objects
        if let animeImages = anime.images {
            self.images = RealmImageFormats(from: animeImages)
        }
        if let animeTrailer = anime.trailer {
            self.trailer = RealmTrailer(from: animeTrailer)
        }
        if let animeAired = anime.aired {
            self.aired = RealmAiredPeriod(from: animeAired)
        }
        if let animeBroadcast = anime.broadcast {
            self.broadcast = RealmBroadcast(from: animeBroadcast)
        }
        // Copy entity lists
        anime.studios?.forEach { self.studios.append(RealmEntity(from: $0)) }
        anime.producers?.forEach { self.producers.append(RealmEntity(from: $0)) }
        anime.licensors?.forEach { self.licensors.append(RealmEntity(from: $0)) }
        anime.genres?.forEach { self.genres.append(RealmEntity(from: $0)) }
        anime.themes?.forEach { self.themes.append(RealmEntity(from: $0)) }
        anime.demographics?.forEach { self.demographics.append(RealmEntity(from: $0)) }
        // Copy streaming links
        anime.streaming?.forEach { self.streaming.append(RealmStreaming(from: $0)) }
    }
    func toJikanAnime() -> JikanAnime {
        var synonymsArray: [String]?
        if !titleSynonyms.isEmpty {
            synonymsArray = Array(titleSynonyms)
        }
        var studiosArray: [JikanEntity]?
        if !studios.isEmpty {
            studiosArray = studios.map { $0.toJikanEntity() }
        }
        var producersArray: [JikanEntity]?
        if !producers.isEmpty {
            producersArray = producers.map { $0.toJikanEntity() }
        }
        var licensorsArray: [JikanEntity]?
        if !licensors.isEmpty {
            licensorsArray = licensors.map { $0.toJikanEntity() }
        }
        var genresArray: [JikanEntity]?
        if !genres.isEmpty {
            genresArray = genres.map { $0.toJikanEntity() }
        }
        var themesArray: [JikanEntity]?
        if !themes.isEmpty {
            themesArray = themes.map { $0.toJikanEntity() }
        }
        var demographicsArray: [JikanEntity]?
        if !demographics.isEmpty {
            demographicsArray = demographics.map { $0.toJikanEntity() }
        }
        var streamingArray: [JikanStreaming]?
        if !streaming.isEmpty {
            streamingArray = streaming.map { $0.toJikanStreaming() }
        }
        return JikanAnime(
            malId: malId,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            titleSynonyms: synonymsArray,
            synopsis: synopsis,
            type: type,
            episodes: episodes,
            duration: duration,
            status: status,
            score: score,
            rank: rank,
            popularity: popularity,
            members: members,
            favorites: favorites,
            images: images?.toJikanImageFormats(),
            trailer: trailer?.toJikanTrailer(),
            aired: aired?.toAiredPeriod(),
            studios: studiosArray,
            producers: producersArray,
            licensors: licensorsArray,
            genres: genresArray,
            themes: themesArray,
            demographics: demographicsArray,
            source: source,
            broadcast: broadcast?.toJikanBroadcast(),
            streaming: streamingArray
        )
    }
}

// MARK: - Images Models
class RealmImageFormats: EmbeddedObject {
    @Persisted var jpg: RealmImage?
    @Persisted var webp: RealmWebPImage?
    convenience init(from formats: JikanImageFormats) {
        self.init()
        if let jpgImage = formats.jpg {
            self.jpg = RealmImage(from: jpgImage)
        }
        if let webpImage = formats.webp {
            self.webp = RealmWebPImage(from: webpImage)
        }
    }
    func toJikanImageFormats() -> JikanImageFormats {
        return JikanImageFormats(
            jpg: jpg?.toJikanImage(),
            webp: webp?.toJikanWebPImage()
        )
    }
}

class RealmImage: EmbeddedObject {
    @Persisted var imageUrl: String?
    @Persisted var largeImageUrl: String?
    @Persisted var smallImageUrl: String?
    convenience init(from image: JikanImage) {
        self.init()
        self.imageUrl = image.imageUrl
        self.largeImageUrl = image.largeImageUrl
        self.smallImageUrl = image.smallImageUrl
    }
    func toJikanImage() -> JikanImage {
        return JikanImage(
            imageUrl: imageUrl,
            largeImageUrl: largeImageUrl,
            smallImageUrl: smallImageUrl
        )
    }
}

class RealmWebPImage: EmbeddedObject {
    @Persisted var imageUrl: String?
    @Persisted var largeImageUrl: String?
    @Persisted var smallImageUrl: String?
    convenience init(from image: JikanWebPImage) {
        self.init()
        self.imageUrl = image.imageUrl
        self.largeImageUrl = image.largeImageUrl
        self.smallImageUrl = image.smallImageUrl
    }
    func toJikanWebPImage() -> JikanWebPImage {
        return JikanWebPImage(
            imageUrl: imageUrl,
            largeImageUrl: largeImageUrl,
            smallImageUrl: smallImageUrl
        )
    }
}

// MARK: - Trailer Models
class RealmTrailer: EmbeddedObject {
    @Persisted var youtubeId: String?
    @Persisted var url: String?
    @Persisted var embedUrl: String?
    @Persisted var images: RealmTrailerImage?
    convenience init(from trailer: JikanTrailer) {
        self.init()
        self.youtubeId = trailer.youtubeId
        self.url = trailer.url
        self.embedUrl = trailer.embedUrl
        if let trailerImages = trailer.images {
            self.images = RealmTrailerImage(from: trailerImages)
        }
    }
    func toJikanTrailer() -> JikanTrailer {
        return JikanTrailer(
            youtubeId: youtubeId,
            url: url,
            embedUrl: embedUrl,
            images: images?.toJikanTrailerImage()
        )
    }
}

class RealmTrailerImage: EmbeddedObject {
    @Persisted var imageUrl: String?
    @Persisted var smallImageUrl: String?
    @Persisted var mediumImageUrl: String?
    @Persisted var largeImageUrl: String?
    @Persisted var maximumImageUrl: String?
    convenience init(from image: JikanTrailerImage) {
        self.init()
        self.imageUrl = image.imageUrl
        self.smallImageUrl = image.smallImageUrl
        self.mediumImageUrl = image.mediumImageUrl
        self.largeImageUrl = image.largeImageUrl
        self.maximumImageUrl = image.maximumImageUrl
    }
    func toJikanTrailerImage() -> JikanTrailerImage {
        return JikanTrailerImage(
            imageUrl: imageUrl,
            smallImageUrl: smallImageUrl,
            mediumImageUrl: mediumImageUrl,
            largeImageUrl: largeImageUrl,
            maximumImageUrl: maximumImageUrl
        )
    }
}

// MARK: - Aired Period Model
class RealmAiredPeriod: EmbeddedObject {
    @Persisted var from: String?
    @Persisted var to: String?
    @Persisted var string: String?
    convenience init(from aired: AiredPeriod) {
        self.init()
        self.from = aired.from
        self.to = aired.to
        self.string = aired.string
    }
    func toAiredPeriod() -> AiredPeriod {
        return AiredPeriod(
            from: from,
            to: to,
            string: string
        )
    }
}

// MARK: - Entity Model
class RealmEntity: EmbeddedObject {
    @Persisted var name: String
    @Persisted var malId: Int
    convenience init(from entity: JikanEntity) {
        self.init()
        self.name = entity.name
        self.malId = entity.malId
    }
    func toJikanEntity() -> JikanEntity {
        return JikanEntity(malId: malId, name: name)
    }
}

// MARK: - Broadcast Model
class RealmBroadcast: EmbeddedObject {
    @Persisted var day: String?
    @Persisted var time: String?
    @Persisted var timezone: String?
    @Persisted var string: String?
    convenience init(from broadcast: JikanBroadcast) {
        self.init()
        self.day = broadcast.day
        self.time = broadcast.time
        self.timezone = broadcast.timezone
        self.string = broadcast.string
    }
    func toJikanBroadcast() -> JikanBroadcast {
        return JikanBroadcast(
            day: day,
            time: time,
            timezone: timezone,
            string: string
        )
    }
}

// MARK: - Streaming Model
class RealmStreaming: EmbeddedObject {
    @Persisted var name: String
    @Persisted var url: String
    convenience init(from streaming: JikanStreaming) {
        self.init()
        self.name = streaming.name
        self.url = streaming.url
    }
    func toJikanStreaming() -> JikanStreaming {
        return JikanStreaming(
            name: name,
            url: url
        )
    }
}
