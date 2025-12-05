//
//  Game.swift
//  AniCue
//
//  Created by Jorge Ramos on 09/08/25.
//
import Foundation
import SwiftUI
struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}
enum MenuSourceType {
    case mainMenu
    case match

    var title: String {
        switch self {
        case .match:
            return "Select Category"
        case .mainMenu:
            return "Select Game"
        }
    }

    var menuItems: [MenuItem] {
        switch self {
        case .match:
            return Constants.matchingMenuItem
        case .mainMenu:
            return Constants.menuItem
        }
    }
    @ViewBuilder
    func destination(for item: MenuItem) -> some View {
        switch self {
        case .match:
            MatchView(source: item.name)
        case .mainMenu:
            switch item.name {
            case "Matching":
                MenuView(sourceType: .match)
            case "Search":
                SearchView()
            case "New Anime":
                NewAnimeView()
            default:
                MenuView(sourceType: .mainMenu)
            }
        }
    }
}
