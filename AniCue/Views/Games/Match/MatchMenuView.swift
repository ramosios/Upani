import SwiftUI

struct MatchMenuView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let menuItemMatching = Constants.matchingMenuItem

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(menuItemMatching) { item in
                        NavigationLink(destination: MatchView(source: item.name)) {
                            MenuCardView(menuItem: item)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select a Category")
        }
        .accentColor(.teal)
    }
}
