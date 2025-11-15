//
//  OpenAIService.swift
//  AniCue
//
//  Created by Jorge Ramos on 14/06/25.
//
import Foundation

class OpenAIService {
    let apiKey: String
    let session: URLSession

    init(apiKey: String = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? "",
         session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    func fetchGenres(from prompt: String) async throws -> [Int] {
        guard !apiKey.isEmpty else { throw OpenAIError.missingAPIKey }
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { throw OpenAIError.invalidResponse }

        let genreMap = Constants.genreDictionary

        let systemPrompt = "You are an assistant that returns only a JSON array of genre IDs. No explanation."
        let userPrompt = "Genre list: \(genreMap). User prompt: \"\(prompt)\". Return a JSON array (max 1 genre ID) matching the prompt. Example: [1]."

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.5
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.serverError(message)
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let message = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyChoices
        }

        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

        // Regex to extract JSON array from text
        let regex = try NSRegularExpression(pattern: "\\[(.*?)\\]", options: [])
        if let match = regex.firstMatch(in: trimmed, options: [], range: NSRange(location: 0, length: trimmed.utf16.count)) {
            let nsRange = match.range
            if let range = Range(nsRange, in: trimmed) {
                let jsonArray = String(trimmed[range])
                if let data = jsonArray.data(using: .utf8) {
                    return try JSONDecoder().decode([Int].self, from: data)
                }
            }
        }

        throw OpenAIError.decodingFailed
    }

    func recommendTopAnime(from animes: [Anime], prompt: String) async throws -> [Anime] {
        guard !apiKey.isEmpty else { throw OpenAIError.missingAPIKey }
        if animes.count <= 5 {
            return animes
        }

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw OpenAIError.invalidResponse
        }

        let titles = animes.prefix(20).map(\.title)

        let systemPrompt = "You are an assistant that returns only a JSON array of anime titles.Avoid recommending more than 1 anime from the same series. No explanation."
        let userPrompt = "User prompt: \"\(prompt)\". From this list, return a JSON array of the 5 best-matching titles: \(titles). Example: [\"Naruto\",\"Bleach\"]."

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.6
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
            throw OpenAIError.serverError(String(data: data, encoding: .utf8) ?? "Unknown error")
        }

        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let content = decoded.choices.first?.message.content else {
            throw OpenAIError.emptyChoices
        }

        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"(?s)\[.*?\]"#
        guard let range = trimmed.range(of: pattern, options: .regularExpression) else {
            throw OpenAIError.decodingFailed
        }

        let jsonString = String(trimmed[range])
        guard let titleData = jsonString.data(using: .utf8) else {
            throw OpenAIError.decodingFailed
        }

        let topTitles = try JSONDecoder().decode([String].self, from: titleData)

        return animes.filter { anime in
            topTitles.contains { $0.caseInsensitiveCompare(anime.title) == .orderedSame }
        }
    }
}
