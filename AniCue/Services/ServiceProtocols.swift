//
//  ServiceProtocols.swift
//  AniCue
//
//  Created by Jorge Ramos on 25/06/25.
//
import Foundation

protocol OpenAIServiceProtocol: AnyObject {
    func fetchGenres(from prompt: String) async throws -> [Int]
    func recommendTopAnime(from animes: [Anime], prompt: String) async throws -> [Anime]
}

protocol JikanServiceProtocol {
}
