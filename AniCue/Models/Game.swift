//
//  Game.swift
//  AniCue
//
//  Created by Jorge Ramos on 09/08/25.
//
import Foundation
struct Game: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let source: GameSource
}
enum GameSource {
    case popular
    case shounen
    case shoujo
    case romance
}
