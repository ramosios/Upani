import Foundation

struct AnimeResponse: Codable {
    let data: Anime
}

struct AnimeListResponse: Codable {
    let data: [Anime]
    let pagination: Pagination?
}

struct Pagination: Codable {
    let lastVisiblePage: Int?
    let hasNextPage: Bool?
    let currentPage: Int?
    let items: Items?

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
        case items
    }
}

struct Items: Codable {
    let count: Int?
    let total: Int?
    let perPage: Int?

    enum CodingKeys: String, CodingKey {
        case count, total
        case perPage = "per_page"
    }
}

struct Anime: Codable {
    let malId: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let titleSynonyms: [String]?
    let synopsis: String?
    let type: String?
    let episodes: Int?
    let duration: String?
    let status: String?
    let score: Double?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let images: ImageFormats?
    let trailer: Trailer?
    let aired: AiredPeriod?
    let studios: [Entity]?
    let producers: [Entity]?
    let licensors: [Entity]?
    let genres: [Entity]?
    let themes: [Entity]?
    let demographics: [Entity]?
    let source: String?
    let broadcast: Broadcast?
    let streaming: [Streaming]?

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case synopsis, type, episodes, duration, status, score, rank, popularity, members, favorites
        case images, trailer, aired, studios, producers, licensors, genres, themes, demographics, source, broadcast, streaming
    }
}

struct ImageFormats: Codable {
    let jpg: AnimeImage?
    let webp: WebPImage?
}

struct AnimeImage: Codable {
    let imageUrl: String?
    let largeImageUrl: String?
    let smallImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case largeImageUrl = "large_image_url"
        case smallImageUrl = "small_image_url"
    }
}

struct WebPImage: Codable {
    let imageUrl: String?
    let largeImageUrl: String?
    let smallImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case largeImageUrl = "large_image_url"
        case smallImageUrl = "small_image_url"
    }
}

struct Trailer: Codable {
    let youtubeId: String?
    let url: String?
    let embedUrl: String?
    let images: TrailerImage?

    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
        case url
        case embedUrl = "embed_url"
        case images
    }
}

struct TrailerImage: Codable {
    let imageUrl: String?
    let smallImageUrl: String?
    let mediumImageUrl: String?
    let largeImageUrl: String?
    let maximumImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case mediumImageUrl = "medium_image_url"
        case largeImageUrl = "large_image_url"
        case maximumImageUrl = "maximum_image_url"
    }
}

struct AiredPeriod: Codable {
    let from: String?
    let to: String?
    let string: String?
}

struct Entity: Codable {
    let malId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case name
    }
}

struct Broadcast: Codable {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String?
}

struct Streaming: Codable {
    let name: String
    let url: String
}
extension Anime: Identifiable {
    var id: Int { malId }
}
