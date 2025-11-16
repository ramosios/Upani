import SwiftUI

struct MenuView: View {
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

    let sourceType: MenuSourceType
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(sourceType.menuItems) { item in
                        NavigationLink(destination: sourceType.destination(for: item)) {
                            MenuCardView(menuItem: item)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(sourceType.title)
        }
        .accentColor(.teal)
    }
}
